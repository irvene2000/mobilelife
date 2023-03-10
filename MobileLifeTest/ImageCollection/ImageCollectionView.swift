//
//  File.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import UIKit

class ImageCollectionView: UIView {
    
    // MARK: - Properties -
    // MARK: Internal
    
    lazy var collectionView: UICollectionView = {
        let newCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        newCollectionView.translatesAutoresizingMaskIntoConstraints = false
        newCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        newCollectionView.showsVerticalScrollIndicator = false
        newCollectionView.showsHorizontalScrollIndicator = false
        return newCollectionView
    }()
    
    // MARK: Private
    
    private lazy var collectionViewFlowLayout: SnappingCollectionViewFlowLayout = {
       let newLayout = SnappingCollectionViewFlowLayout()
        newLayout.scrollDirection = .horizontal
        return newLayout
    }()
    
    // MARK: - View Lifecycle -
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private API -
    // MARK: Setup Methods
    
    private func setupSubviews() {
        backgroundColor = .white
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
