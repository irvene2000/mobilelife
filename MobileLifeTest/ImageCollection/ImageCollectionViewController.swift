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
    
    // MARK: - Controller Lifecycle -
    
    override func loadView() {
        view = ImageCollectionView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        viewModel.imageViewModels.subscribe { [weak self] pictures in
            guard let strongSelf = self else { return }
            strongSelf.rootView.collectionView.reloadData()
        }.disposed(by: disposeBag)
//        viewModel.imageDownloaded.subscribe { [weak self] index in
//            guard let strongSelf = self else { return }
//            strongSelf.viewModel.downloadImage(at: index, scale: 0.2 * strongSelf.traitCollection.displayScale)
//        }.disposed(by: disposeBag)
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
}

extension ImageCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageViewModels.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.viewModel = viewModel.imageViewModels.value[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.row
        let size = viewModel.imageViewModels.value[index].actualSize.value
        return size.fittingInScreen(scale: 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.greatestFiniteMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            // Download thumbnail at 20% of original size and accounting for screen's display scale
            viewModel.downloadImage(at: indexPath.row, scale: 0.2 * traitCollection.displayScale)
        }
    }
}