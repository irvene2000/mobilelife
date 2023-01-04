//
//  ImageDetailViewModel.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 04/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol ImageDetailViewModelType {
    var imageRelay: BehaviorRelay<UIImage?> { get }
}

class ImageDetailViewModel: ImageDetailViewModelType {

    // MARK: - Properties -
    // MARK: Internal
    
    var imageRelay: BehaviorRelay<UIImage?>
    
    // MARK: Private
    
    private var disposeBag: DisposeBag! = DisposeBag()
    
    init(picture: Picture) {
        imageRelay = BehaviorRelay(value: picture.image)
    }
    
    // MARK: - Internal API -
    // MARK: Lifecycle Methods
    
    deinit {
        disposeBag = nil
    }
}
