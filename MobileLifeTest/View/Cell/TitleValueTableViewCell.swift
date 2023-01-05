//
//  TitleValueTableViewCell.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 04/01/2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class TitleValueTableViewCell: UITableViewCell {
    // MARK: - Properties -
    // MARK: Internal
    
    var viewModel: TitleValueTableViewCellViewModelType! {
        didSet {
            setupListeners()
        }
    }
    
    // MARK: Private
    
    private var titleLabel: UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = UIFont.systemFont(ofSize: 12.0)
        return newLabel
    }()
    
    private var valueLabel: UILabel = {
        let newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = UIFont.systemFont(ofSize: 20.0)
        newLabel.adjustsFontSizeToFitWidth = true
        return newLabel
    }()
    private var disposeBag: DisposeBag! = DisposeBag()
    
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
    
    override func prepareForReuse() {
        viewModel = nil
        disposeBag = DisposeBag()
    }
    
    // MARK: - Private API -
    
    private func setupSubviews() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20.0),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupListeners() {
        guard let viewModel = viewModel else { return }
        
        viewModel.titleRelay.subscribe { [weak self] title in
            guard let strongSelf = self else { return }
            strongSelf.titleLabel.text = title
        }.disposed(by: disposeBag)
        viewModel.valueRelay.subscribe { [weak self] value in
            guard let strongSelf = self else { return }
            strongSelf.valueLabel.text = value
        }.disposed(by: disposeBag)
    }
}

protocol TitleValueTableViewCellViewModelType {
    var titleRelay: BehaviorRelay<String> { get }
    var valueRelay: BehaviorRelay<String> { get }
}

class TitleValueTableViewCellViewModel: TitleValueTableViewCellViewModelType {
    var titleRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    var valueRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
}
