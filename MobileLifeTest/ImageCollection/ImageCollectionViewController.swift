//
//  ViewController.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ImageCollectionViewController: UIViewController {
    
    // MARK: - Properties -
    // MARK: Internal
    
    var rootView: ImageCollectionView {
        return view as! ImageCollectionView
    }
    var viewModel: ImageCollectionViewModelType = ImageCollectionViewModel()
    
    // MARK: Private
    
    private var disposeBag: DisposeBag! = DisposeBag()
    private var visibleIndexPath: IndexPath?
    private var imageScale: CGFloat {
        return 0.5 * traitCollection.displayScale
    }
    
    // MARK: - Internal API -
    // MARK: Controller Lifecycle
    
    override func loadView() {
        view = ImageCollectionView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupListeners()
    }
    
    deinit {
        disposeBag = nil
    }
    
    // MARK: - Private API -
    // MARK: Setup Methods
    
    private func setupViews() {
        rootView.collectionView.prefetchDataSource = self
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func setupListeners() {
        viewModel.imageViewModelsRelay.subscribe(onNext: { [weak self] pictures in
            guard let strongSelf = self else { return }
            
            let picturesCount = min(2, pictures.count)
            for i in 0 ..< picturesCount {
                strongSelf.viewModel.downloadImage(at: i, scale: strongSelf.imageScale)
            }
            
            strongSelf.rootView.collectionView.reloadData()
        }).disposed(by: disposeBag)
        viewModel.failedToLoadImageRelay.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            let alertController = UIAlertController(title: "Failed to load", message: "Click retry to attempt again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                strongSelf.viewModel.retrieveNextSetOfImages()
            }))
            strongSelf.present(alertController, animated: true)
        }).disposed(by: disposeBag)
    }
    
}

extension ImageCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageViewModelsRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.viewModel = viewModel.imageViewModelsRelay.value[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.row
        let size = viewModel.imageViewModelsRelay.value[index].actualSizeRelay.value
        return size.fittingInScreen(scale: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.greatestFiniteMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            // Download thumbnail at 20% of original size and accounting for screen's display scale
            viewModel.downloadImage(at: indexPath.row, scale: imageScale)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard targetContentOffset.pointee.x >= CGRectGetMaxX(scrollView.bounds) -  UIScreen.main.bounds.width else {
            return
        }
        
        viewModel.retrieveNextSetOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Coordinator.navigateToImageDetail(selectedPictureIndex: indexPath.row, pictures: viewModel.picturesRelay)
    }
}
