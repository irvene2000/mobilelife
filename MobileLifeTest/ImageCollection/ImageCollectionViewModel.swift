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
    var imageDownloaded: PublishRelay<Int> { get }
    var imageViewModels: BehaviorRelay<[ImageCollectionViewCellViewModelType]> { get }
    
    func downloadImage(at index: Int, scale: CGFloat)
    func retrieveNextSetOfImages()
}

class ImageCollectionViewModel: ImageCollectionViewModelType {
    // MARK: - Properties -
    // MARK: Internal
    
    var imageDownloaded = PublishRelay<Int>()
    var imageViewModels: BehaviorRelay<[ImageCollectionViewCellViewModelType]> = BehaviorRelay(value: [])
    
    // MARK: Private
    
    private var images: BehaviorRelay<[Picture]> = BehaviorRelay(value: [])
//    private var thumbnailCache = [String: UIImage]()
    private var imageCache = [String: UIImage]()
    private var disposeBag: DisposeBag! = DisposeBag()
    private var api: APIType.Type = API.self
    private var pageCount: Int = 1
    private var isLoadingImages: Bool = false
    
    // MARK: - Initializer -
    
    init() {
        setupListeners()
        
        retrieveNextSetOfImages()
    }
    
    deinit {
        disposeBag = nil
    }
    
    // MARK: - Internal API -
    
    func downloadImage(at index: Int, scale: CGFloat) {
        guard index < images.value.count else { return }
        
        let picture = images.value[index]
        let actualPictureSize = CGSize(width: picture.width, height: picture.height)
        let imageSizeFittingInScreen = actualPictureSize.fittingInScreen(scale: scale)
        let thumbnailURLString = "https://picsum.photos/id/\(picture.id)/\(Int(imageSizeFittingInScreen.width))/\(Int(imageSizeFittingInScreen.height))"
        
        guard let url = URL(string: thumbnailURLString) else { return }
        guard imageCache[picture.id] == nil else {
            imageDownloaded.accept(index)
            return
        }
        
        downloadImage(at: url) { image in
            self.imageCache[picture.id] = image
            self.imageViewModels.value[index].image.accept(image)
            self.imageDownloaded.accept(index)
        }
    }
    
    func retrieveNextSetOfImages() {
        guard !isLoadingImages else { return }
        
        isLoadingImages = true
        
        api.retrieveImages(page: pageCount).subscribe { [weak self] pictures in
                guard let strongSelf = self else { return }
            var imageList = strongSelf.images.value
            imageList.append(contentsOf: pictures)
            strongSelf.images.accept(imageList)
                strongSelf.pageCount += 1
            strongSelf.isLoadingImages = false
        } onFailure: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingImages = false
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Private API -
    
    private func setupListeners() {
        images.subscribe { [weak self] pictures in
            guard let strongSelf = self else { return }
            let newImageViewModels = pictures.map { picture in
                let imageViewModel = ImageCollectionViewCellViewModel()
                imageViewModel.actualSize.accept(CGSize(width: picture.width, height: picture.height))
                return imageViewModel
            }
            
            var imageList = strongSelf.imageViewModels.value
            imageList.append(contentsOf: newImageViewModels)
            strongSelf.imageViewModels.accept(imageList)
        }.disposed(by: disposeBag)
    }
    
    private func downloadImage(at url: URL, completion: @escaping ((UIImage?) -> Void)) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
           
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

