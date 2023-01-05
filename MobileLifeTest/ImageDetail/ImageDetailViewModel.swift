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
    var segmentsRelay: BehaviorRelay<SegmentedControlTableViewCellViewModelType> { get }
    var authorRelay: BehaviorRelay<TitleValueTableViewCellViewModelType> { get }
    var dimensionRelay: BehaviorRelay<TitleValueTableViewCellViewModelType> { get }
    var identifierRelay: BehaviorRelay<TitleValueTableViewCellViewModelType> { get }
    var urlRelay: BehaviorRelay<TitleValueTableViewCellViewModelType> { get }
    var downloadURLRelay: BehaviorRelay<TitleValueTableViewCellViewModelType> { get }
    
    func toggleNormalImage()
    func toggleBlurredImage(blurIndex: Int)
    func toggleGrayscaleImage()
}

class ImageDetailViewModel: ImageDetailViewModelType {

    // MARK: - Properties -
    // MARK: Internal
    
    var imageRelay: BehaviorRelay<UIImage?>
    var segmentsRelay: BehaviorRelay<SegmentedControlTableViewCellViewModelType>
    var authorRelay: BehaviorRelay<TitleValueTableViewCellViewModelType>
    var dimensionRelay: BehaviorRelay<TitleValueTableViewCellViewModelType>
    var identifierRelay: BehaviorRelay<TitleValueTableViewCellViewModelType>
    var urlRelay: BehaviorRelay<TitleValueTableViewCellViewModelType>
    var downloadURLRelay: BehaviorRelay<TitleValueTableViewCellViewModelType>
    
    // MARK: Private
    
    private var disposeBag: DisposeBag! = DisposeBag()
    private let normalKey = "Normal"
    private let blurredKey = "Blur"
    private let grayscaleKey = "GrayScale"
    private var imageCache = [String: UIImage]()
    
    init(picture: Picture) {
        imageRelay = BehaviorRelay(value: picture.image)
        
        imageCache[normalKey] = picture.image
        
        let segmentedViewModel = SegmentedControlTableViewCellViewModel()
        segmentsRelay = BehaviorRelay(value: segmentedViewModel)
        
        let authorViewModel = TitleValueTableViewCellViewModel()
        authorViewModel.titleRelay.accept(NSLocalizedString("ImageDetailViewController.TitleLabel.Author", comment: "Author Title Label"))
        authorViewModel.valueRelay.accept(picture.author)
        authorRelay = BehaviorRelay(value: authorViewModel)
        
        let dimensionViewModel = TitleValueTableViewCellViewModel()
        dimensionViewModel.titleRelay.accept(NSLocalizedString("ImageDetailViewController.TitleLabel.Dimensions", comment: "Dimensions Title Label"))
        dimensionViewModel.valueRelay.accept("\(picture.width)px / \(picture.height)px")
        dimensionRelay = BehaviorRelay(value: dimensionViewModel)
        
        let identifierViewModel = TitleValueTableViewCellViewModel()
        identifierViewModel.titleRelay.accept(NSLocalizedString("ImageDetailViewController.TitleLabel.Identifier", comment: "Identifier Title Label"))
        identifierViewModel.valueRelay.accept(picture.id)
        identifierRelay = BehaviorRelay(value: identifierViewModel)
        
        let urlViewModel = TitleValueTableViewCellViewModel()
        urlViewModel.titleRelay.accept(NSLocalizedString("ImageDetailViewController.TitleLabel.URL", comment: "URL Title Label"))
        urlViewModel.valueRelay.accept(picture.url.value?.absoluteString ?? "")
        urlRelay = BehaviorRelay(value: urlViewModel)
        
        let downloadURLViewModel = TitleValueTableViewCellViewModel()
        downloadURLViewModel.titleRelay.accept(NSLocalizedString("ImageDetailViewController.TitleLabel.DownloadURL", comment: "Download URL Title Label"))
        downloadURLViewModel.valueRelay.accept(picture.url.value?.absoluteString ?? "")
        downloadURLRelay = BehaviorRelay(value: downloadURLViewModel)
    }
    
    // MARK: - Internal API -
    // MARK: Lifecycle Methods
    
    deinit {
        disposeBag = nil
    }
    
    // MARK: ImageDetailViewModel Actions
    
    func toggleNormalImage() {
        retrieveImage(key: normalKey)
    }
    
    func toggleBlurredImage(blurIndex: Int) {
        let blurIndexKey = "\(blurredKey)-\(blurIndex)"
        retrieveImage(key: blurIndexKey)
    }
    
    func toggleGrayscaleImage() {
        retrieveImage(key: grayscaleKey)
    }
    
    // MARK: - Private API -
    // MARK: Convenience Methods
    
    private func retrieveImage(key: String){
        if let cachedImage = imageCache[key] {
            imageRelay.accept(cachedImage)
        }
        else {
            imageRelay.accept(nil)
        }
    }
}

extension Picture {
    var dimensionDescription: String {
        return "\(width)px / \(height)px"
    }
}
