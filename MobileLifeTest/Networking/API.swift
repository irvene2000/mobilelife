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

protocol APIType {
    static func retrieveImages() -> Single<[Picture]>
}

enum API: APIType {
    static var disposeBag = DisposeBag()
    
    static func retrieveImages() -> Single<[Picture]> {
        RxAlamofire.request(.get, "https://picsum.photos/v2/list")
            .responseData()
            .map({ (_, data) in
                return try JSONDecoder().decode([Picture].self, from: data)
            })
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
}

enum APIError: Error {
    case retrieveImages
}