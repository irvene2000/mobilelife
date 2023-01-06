//
//  API.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import RxAlamofire
import RxSwift
import SwiftyJSON

public protocol APIType {
    static func retrieveImages(page: Int) -> Single<[Picture]>
    static func downloadImage(id: String, size: CGSize, variant: PictureVariant) -> Single<UIImage>
}

enum API: APIType {
    static var disposeBag = DisposeBag()
    
    static func retrieveImages(page: Int = 1) -> Single<[Picture]> {
        RxAlamofire.request(.get, "https://picsum.photos/v2/list?page=\(page)")
            .responseData()
            .map({ (_, data) in
                return try JSONDecoder().decode([Picture].self, from: data)
            })
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
    
    static func downloadImage(id: String, size: CGSize, variant: PictureVariant) -> Single<UIImage> {
        let single = Single.create { single in
            let disposable = Disposables.create()
            
            var thumbnailURLString = "https://picsum.photos/id/\(id)/\(Int(size.width))/\(Int(size.height))"
            
            switch variant {
            case let .blur(index):
                thumbnailURLString.append("/?blur=\(index)")
            case .grayscale:
                thumbnailURLString.append("/?grayscale")
            default:
                break
            }
            
            guard let url = URL(string: thumbnailURLString) else { return disposable }
            
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
               
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    single(.success(image))
                }
            }
            
            return disposable
        }
        
        return single
    }
}

enum APIError: Error {
    case retrieveImages
}
