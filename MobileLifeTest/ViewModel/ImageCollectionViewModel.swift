//
//  ImageCollectionViewModel.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import RxSwift
import RxAlamofire
import RxCocoa

protocol ImageCollectionViewModelType {
    var images: BehaviorRelay<[Pictures]> { get }
}

class ImageCollectionViewModel: ImageCollectionViewModelType {
    // MARK: - Properties -
    var images: BehaviorRelay<[Pictures]> = BehaviorRelay(value: [])
    
    // MARK: Private
    
    private var disposeBag = DisposeBag()
    private var api: APIType.Type = API.self
    
    init() {
        api.retrieveImages().subscribe { [weak self] pictures in
            guard let strongSelf = self else { return }
            strongSelf.images.accept(pictures)
        }.disposed(by: disposeBag)
    }
}
