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
    var imageDownloadedRelay: PublishRelay<(Int, UIImage)> { get }
    var imageViewModelsRelay: BehaviorRelay<[ImageCollectionViewCellViewModelType]> { get }
    var picturesRelay: BehaviorRelay<[Picture]> { get }
    var failedToLoadImageRelay: PublishRelay<Void> { get }
    
    func downloadImage(at index: Int, scale: CGFloat)
    func retrieveNextSetOfImages()
}

class ImageCollectionViewModel: ImageCollectionViewModelType {
    // MARK: - Properties -
    // MARK: Internal
    
    var imageDownloadedRelay = PublishRelay<(Int, UIImage)>()
    var imageViewModelsRelay: BehaviorRelay<[ImageCollectionViewCellViewModelType]> = BehaviorRelay(value: [])
    var picturesRelay: BehaviorRelay<[Picture]> = BehaviorRelay(value: [])
    var failedToLoadImageRelay = PublishRelay<Void>()
    
    // MARK: Private
    
    private var disposeBag: DisposeBag! = DisposeBag()
    private var api: APIType.Type
    private var pageCount: Int = 1
    private var isLoadingImages: Bool = false
    
    // MARK: - Initializer -
    
    init(api: APIType.Type = API.self) {
        self.api = api
        retrieveNextSetOfImages()
    }
    
    deinit {
        disposeBag = nil
    }
    
    // MARK: - Internal API -
    
    func downloadImage(at index: Int, scale: CGFloat) {
        guard index < picturesRelay.value.count else { return }
        
        let picture = picturesRelay.value[index]
        let cachedImage = picture.imageCache[.normal]
        
        guard cachedImage == nil else {
            imageDownloadedRelay.accept((index, cachedImage!))
            return
        }
        
        let imageSizeFittingInScreen = picture.imageSizeFittingInScreen(scale: scale)
        api.downloadImage(id: picture.id, size: imageSizeFittingInScreen, variant: .normal).subscribe(onSuccess: { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.imageViewModelsRelay.value[index].imageRelay.accept(image)
            strongSelf.imageDownloadedRelay.accept((index, image))

            var pictures = strongSelf.picturesRelay.value
            pictures[index].imageCache[.normal] = image
            strongSelf.picturesRelay.accept(pictures)
        }).disposed(by: disposeBag)
    }
    
    func retrieveNextSetOfImages() {
        guard !isLoadingImages else { return }
        
        isLoadingImages = true
        
        api.retrieveImages(page: pageCount).subscribe(onSuccess: { [weak self] pictures in
                guard let strongSelf = self else { return }
            var imageList = strongSelf.picturesRelay.value
            imageList.append(contentsOf: pictures)
            strongSelf.processPictures(pictures: imageList)
            strongSelf.pageCount += 1
            strongSelf.isLoadingImages = false
        }, onFailure: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingImages = false
            strongSelf.failedToLoadImageRelay.accept(())
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private API -
    
    private func processPictures(pictures: [Picture]) {
        picturesRelay.accept(pictures)
        
        let newImageViewModels = pictures.map { picture in
            let imageViewModel = ImageCollectionViewCellViewModel()
            imageViewModel.actualSizeRelay.accept(CGSize(width: picture.width, height: picture.height))
            return imageViewModel
        }

        var imageList = imageViewModelsRelay.value
        imageList.append(contentsOf: newImageViewModels)
        imageViewModelsRelay.accept(imageList)
    }
}

