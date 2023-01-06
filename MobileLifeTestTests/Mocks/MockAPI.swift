//
//  MockAPI.swift
//  MobileLifeTestTests
//
//  Created by Tan Way Loon on 06/01/2023.
//

import Foundation
import RxSwift
import RxCocoa
@testable import MobileLifeTest

class MockAPI: APIType {
    enum RetrieveImagesReturn {
        case empty
        case singlePicture
        case multiplePicture
    }
    static var retrieveImagesReturn: RetrieveImagesReturn = .empty
    
    static func retrieveImages(page: Int) -> Single<[Picture]> {
        return Single.create { single in
            let disposable = Disposables.create()
            
            var picturesArray = [Picture]()
            
            switch retrieveImagesReturn {
            case .singlePicture:
                let mockPicture = createMockPicture()
                picturesArray.append(mockPicture)
            case .multiplePicture:
                let mockPicture1 = createMockPicture()
                let mockPicture2 = createMockPicture()
                let mockPicture3 = createMockPicture()
                picturesArray.append(contentsOf: [mockPicture1, mockPicture2, mockPicture3])
            default:
                break
            }
            
            single(.success(picturesArray))
            return disposable
        }
    }
    
    static func downloadImage(id: String, size: CGSize, variant: PictureVariant) -> Single<UIImage> {
        return Single.create { single in
            let disposable = Disposables.create()
            single(.success(UIImage()))
            return disposable
        }
    }
    
    private static func createMockPicture() -> Picture {
        return Picture(author: "Test",
                       downloadURL: URLType(value: nil),
                       height: 100,
                       id: "1",
                       url: URLType(value: nil),
                       width: 100,
                       imageCache: [:])
    }
}
