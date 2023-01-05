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
    var imageDownloaded: PublishRelay<(Int, UIImage)> { get }
    var imageViewModels: BehaviorRelay<[ImageCollectionViewCellViewModelType]> { get }
    var images: BehaviorRelay<[Picture]> { get }
    
    func downloadImage(at index: Int, scale: CGFloat)
    func retrieveNextSetOfImages()
}

class ImageCollectionViewModel: ImageCollectionViewModelType {
    // MARK: - Properties -
    // MARK: Internal
    
    var imageDownloaded = PublishRelay<(Int, UIImage)>()
    var imageViewModels: BehaviorRelay<[ImageCollectionViewCellViewModelType]> = BehaviorRelay(value: [])
    var images: BehaviorRelay<[Picture]> = BehaviorRelay(value: [])
    
    // MARK: Private
    
    private var disposeBag: DisposeBag! = DisposeBag()
    private var api: APIType.Type = API.self
    private var pageCount: Int = 1
    private var isLoadingImages: Bool = false
    
    // MARK: - Initializer -
    
    init() {
        retrieveNextSetOfImages()
    }
    
    deinit {
        disposeBag = nil
    }
    
    // MARK: - Internal API -
    
    func downloadImage(at index: Int, scale: CGFloat) {
        guard index < images.value.count else { return }
        
        let picture = images.value[index]
        let cachedImage = picture.imageCache[.normal]
        
        guard cachedImage == nil else {
            imageDownloaded.accept((index, cachedImage!))
            return
        }
        
        let imageSizeFittingInScreen = picture.imageSizeFittingInScreen(scale: scale)
        
        api.downloadImage(id: picture.id, size: CGSize(width: imageSizeFittingInScreen.width, height: imageSizeFittingInScreen.height), variant: .normal) { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.imageViewModels.value[index].image.accept(image)
            strongSelf.imageDownloaded.accept((index, image))
            
            var pictures = strongSelf.images.value
            pictures[index].imageCache[.normal] = image
            strongSelf.images.accept(pictures)
        }
    }
    
    func retrieveNextSetOfImages() {
        guard !isLoadingImages else { return }
        
        isLoadingImages = true
        
        api.retrieveImages(page: pageCount).subscribe { [weak self] pictures in
                guard let strongSelf = self else { return }
            var imageList = strongSelf.images.value
            imageList.append(contentsOf: pictures)
            strongSelf.processPictures(pictures: imageList)
            strongSelf.pageCount += 1
            strongSelf.isLoadingImages = false
        } onFailure: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingImages = false
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Private API -
    
    private func processPictures(pictures: [Picture]) {
        images.accept(pictures)
        
        let newImageViewModels = pictures.map { picture in
            let imageViewModel = ImageCollectionViewCellViewModel()
            imageViewModel.actualSize.accept(CGSize(width: picture.width, height: picture.height))
            return imageViewModel
        }

        var imageList = imageViewModels.value
        imageList.append(contentsOf: newImageViewModels)
        imageViewModels.accept(imageList)
    }
}

