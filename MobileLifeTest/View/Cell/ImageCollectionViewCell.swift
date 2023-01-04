//
//  ImageCollectionViewCell.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ImageCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties -
    // MARK: Internal
    
    public var viewModel: ImageCollectionViewCellViewModelType? {
        didSet {
            rebindViewModel()
        }
    }
    
    // MARK: Private
    
    private let imageView: UIImageView = {
        let newImageView = UIImageView()
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        return newImageView
    }()
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers -
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rebindViewModel() {
        viewModel?.image.subscribe(onNext: { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.imageView.image = image
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private API -
    // MARK: Setup Methods
    
    private func setupSubviews() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

protocol ImageCollectionViewCellViewModelType {
    var image: BehaviorRelay<UIImage?> { get }
    var actualSize: BehaviorRelay<CGSize> { get }
}

struct ImageCollectionViewCellViewModel: ImageCollectionViewCellViewModelType {
    var image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var actualSize: BehaviorRelay<CGSize> = BehaviorRelay(value: .zero)
}
