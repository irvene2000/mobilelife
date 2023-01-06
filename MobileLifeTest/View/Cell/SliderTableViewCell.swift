//
//  SliderTableViewCell.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 05/01/2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SliderTableViewCell: UITableViewCell {
    
    // MARK: - Properties -
    // MARK: Internal
    
    var viewModel: SliderTableViewCellViewModelType! = SliderTableViewCellViewModel() {
        didSet {
            setupListeners()
        }
    }
    var slider: UISlider = {
        let newSlider = UISlider()
        newSlider.translatesAutoresizingMaskIntoConstraints = false
        newSlider.isContinuous = false
        return newSlider
    }()
    
    // MARK: Private

    private var disposeBag: DisposeBag! = DisposeBag()
    private var minLabel: UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        newLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        newLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return newLabel
    }()
    private var maxLabel: UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        newLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        newLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return newLabel
    }()
    private var rootStackView: UIStackView = {
        let newStackView = UIStackView()
        newStackView.translatesAutoresizingMaskIntoConstraints = false
        newStackView.axis = .horizontal
        newStackView.spacing = 20.0
        return newStackView
    }()
    
    // MARK: - Initializer -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupListeners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal API -
    // MARK: Lifecycle Methods
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    private func setupSubviews() {
        contentView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubview(minLabel)
        rootStackView.addArrangedSubview(slider)
        rootStackView.addArrangedSubview(maxLabel)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            rootStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
        ])
    }
    
    private func setupListeners() {
        slider.rx.value.subscribe(onNext: { [weak self] sliderValue in
            guard let strongSelf = self else { return }
            let roundedValue = Int(sliderValue + 0.5)
            strongSelf.slider.value = Float(roundedValue)
        }).disposed(by: disposeBag)
        slider.rx.value.map({ value in
            guard value != 0 else { return 1 }
            return Int(value)
        }).bind(to: viewModel.sliderValueRelay).disposed(by: disposeBag)
        viewModel.minTitleRelay.subscribe(onNext: { [weak self] minValue in
            guard let strongSelf = self else { return }
            strongSelf.minLabel.text = "\(minValue)"
            strongSelf.slider.minimumValue = Float(minValue)
        }).disposed(by: disposeBag)
        viewModel.maxTitleRelay.subscribe(onNext: { [weak self] maxValue in
            guard let strongSelf = self else { return }
            strongSelf.maxLabel.text = "\(maxValue)"
            strongSelf.slider.maximumValue = Float(maxValue)
        }).disposed(by: disposeBag)
    }
}

protocol SliderTableViewCellViewModelType {
    var minTitleRelay: BehaviorRelay<Int> { get }
    var maxTitleRelay: BehaviorRelay<Int> { get }
    var sliderValueRelay: BehaviorRelay<Int> { get }
}

class SliderTableViewCellViewModel: SliderTableViewCellViewModelType {
    var minTitleRelay = BehaviorRelay(value: 1)
    var maxTitleRelay = BehaviorRelay(value: 0)
    var sliderValueRelay = BehaviorRelay(value: 1)
}
