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
    private var isDisplayingSlider: Bool = false
    
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
        viewModel.sliderRelay.subscribe(onNext: { [weak self] viewModel in
            guard let strongSelf = self else { return }
            strongSelf.rootView.infoTableView.beginUpdates()
        
            if viewModel != nil && !strongSelf.isDisplayingSlider {
                strongSelf.isDisplayingSlider.toggle()
                strongSelf.rootView.infoTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
            else if viewModel == nil && strongSelf.isDisplayingSlider {
                strongSelf.isDisplayingSlider.toggle()
                strongSelf.rootView.infoTableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
            
            strongSelf.rootView.infoTableView.endUpdates()
        }).disposed(by: disposeBag)
        
        rootView.infoTableView.delegate = self
        rootView.infoTableView.dataSource = self
        rootView.infoTableView.register(TitleValueTableViewCell.self, forCellReuseIdentifier: "TitleValueTableViewCell")
        rootView.infoTableView.register(SliderTableViewCell.self, forCellReuseIdentifier: "SliderTableViewCell")
        rootView.infoTableView.register(SegmentedControlTableViewCell.self, forCellReuseIdentifier: "SegmentedControlTableViewCell")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let newVerticalSizeClass: UIUserInterfaceSizeClass = size.width > size.height ? .compact : .regular
        rootView.configureView(for: newVerticalSizeClass)
    }
    
    deinit {
        disposeBag = nil
    }
}

extension ImageDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.sliderRelay.value != nil ? 2 : 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let newCell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlTableViewCell", for: indexPath) as! SegmentedControlTableViewCell
                newCell.viewModel = viewModel.segmentsRelay.value
                let actions = [
                    UIAction(title: NSLocalizedString("ImageDetailViewController.SegmentTitle.Normal", comment: "Normal Segment"), handler: { action in
                        self.viewModel.toggleNormalImage()
                    }),
                    UIAction(title: NSLocalizedString("ImageDetailViewController.SegmentTitle.Blur", comment: "Blur Segment"), handler: { action in
                        self.viewModel.toggleBlurredImage()
                    }),
                    UIAction(title: NSLocalizedString("ImageDetailViewController.SegmentTitle.Grayscale", comment: "Grayscale Segment"), handler: { action in
                        self.viewModel.toggleGrayscaleImage()
                    })
                ]
                viewModel.segmentsRelay.value.segmentsRelay.accept(actions)
                viewModel.segmentsRelay.value.selectedSegmentIndexRelay.accept(0)
                cell = newCell
            case 1:
                let newCell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
                newCell.viewModel = viewModel.sliderRelay.value
                cell = newCell
            default:
                break
            }
        case 1:
            let newCell = tableView.dequeueReusableCell(withIdentifier: "TitleValueTableViewCell", for: indexPath) as! TitleValueTableViewCell
            switch indexPath.row {
            case 0:
                newCell.viewModel = viewModel.authorRelay.value
            case 1:
                newCell.viewModel = viewModel.dimensionRelay.value
            case 2:
                newCell.viewModel = viewModel.identifierRelay.value
            case 3:
                newCell.viewModel = viewModel.urlRelay.value
            case 4:
                newCell.viewModel = viewModel.downloadURLRelay.value
            default:
                break
            }
            cell = newCell
        default:
            break
        }
        
        return cell
    }
}

