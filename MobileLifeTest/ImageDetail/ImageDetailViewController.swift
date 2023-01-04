//
//  ImageDetailViewController.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 04/01/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ImageDetailViewController: UIViewController {
    
    // MARK: - Properties -
    // MARK: Private
    
    private var rootView: ImageDetailView {
        return view as! ImageDetailView
    }
    private var viewModel: ImageDetailViewModelType
    private var disposeBag: DisposeBag! = DisposeBag()
    
    // MARK: - Initializer -
    
    init(viewModel: ImageDetailViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal API -
    // MARK: Controller Lifecycle
    
    override func loadView() {
        view = ImageDetailView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.configureView(for: traitCollection.verticalSizeClass)
        
        viewModel.imageRelay.subscribe { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.rootView.imageView.image = image
        }.disposed(by: disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let newVerticalSizeClass: UIUserInterfaceSizeClass = size.width > size.height ? .compact : .regular
        rootView.configureView(for: newVerticalSizeClass)
    }
    
    deinit {
        disposeBag = nil
    }
}
