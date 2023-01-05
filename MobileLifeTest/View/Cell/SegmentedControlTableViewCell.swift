//
//  SegmentedControlTableViewCell.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 05/01/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SegmentedControlTableViewCell: UITableViewCell {
    
    // MARK: - Properties -
    // MARK: Internal
    
    var viewModel: SegmentedControlTableViewCellViewModelType! {
        didSet {
            setupListeners()
        }
    }
    
    // MARK: Private
    
    private var segmentedControl: UISegmentedControl = {
        let newSegmentedControl = UISegmentedControl()
        newSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return newSegmentedControl
    }()
    private var disposeBag: DisposeBag! = DisposeBag()
    
    // MARK: - Initializers -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal API -
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    // MARK: - Private API -
    
    private func setupSubviews() {
        selectionStyle = .none
        
        contentView.addSubview(segmentedControl)
        
        let segmentedControlLeadingConstraint = segmentedControl.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20.0)
        segmentedControlLeadingConstraint.priority = UILayoutPriority(rawValue: 749)
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            segmentedControlLeadingConstraint
        ])
    }
    
    private func setupListeners() {
        viewModel.segments.subscribe { [weak self] actions in
            guard let strongSelf = self else { return }
            strongSelf.segmentedControl.removeAllSegments()
            
            for (index, action) in actions.enumerated() {
                strongSelf.segmentedControl.insertSegment(action: action, at: index, animated: false)
            }
        }.disposed(by: disposeBag)
        
        viewModel.selectedSegmentIndex.subscribe(onNext: { [weak self] index in
            guard let strongSelf = self else { return }
            strongSelf.segmentedControl.selectedSegmentIndex = index ?? 0
        }).disposed(by: disposeBag)
    }
}

protocol SegmentedControlTableViewCellViewModelType {
    var segments: BehaviorRelay<[UIAction]> { get }
    var selectedSegmentIndex: BehaviorRelay<Int?> { get }
}

class SegmentedControlTableViewCellViewModel: SegmentedControlTableViewCellViewModelType {
    var segments: BehaviorRelay<[UIAction]> = BehaviorRelay(value: [])
    var selectedSegmentIndex: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
}
