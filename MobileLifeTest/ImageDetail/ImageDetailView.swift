//
//  ImageDetailView.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 04/01/2023.
//

import Foundation
import UIKit

class ImageDetailView: UIView {
    
    // MARK: - Properties -
    // MARK: Internal
    
    var imageView: UIImageView = {
        let newImageView = UIImageView()
        newImageView.contentMode = .scaleAspectFit
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        return newImageView
    }()
    var infoTableView: UITableView = {
        let newTableView = UITableView(frame: .zero, style: .plain)
        newTableView.translatesAutoresizingMaskIntoConstraints = false
        newTableView.showsVerticalScrollIndicator = false
        return newTableView
    }()
    
    // MARK: Private
    
    private var stackView: UIStackView = {
        let newStackView = UIStackView()
        newStackView.translatesAutoresizingMaskIntoConstraints = false
        newStackView.axis = .vertical
        newStackView.backgroundColor = .black
        return newStackView
    }()
    private var primaryView: UIStackView = {
        let newView = UIStackView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = .black
        return newView
    }()
    private var secondaryView: UIStackView = {
        let newView = UIStackView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = .white
        return newView
    }()
    
    private var secondaryViewHeightConstraint: NSLayoutConstraint!
    private var secondaryViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        configureView(for: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal API -
    // MARK: Configure views
    
    func configureView(for verticalSizeClass: UIUserInterfaceSizeClass) {
        switch verticalSizeClass {
        case .regular:
            stackView.axis = .vertical
            secondaryViewHeightConstraint.constant = 0.333 * UIScreen.main.bounds.height
            secondaryViewWidthConstraint.constant = UIScreen.main.bounds.width
        case .compact:
            stackView.axis = .horizontal
            secondaryViewHeightConstraint.constant = UIScreen.main.bounds.height
            secondaryViewWidthConstraint.constant = 0.333 * UIScreen.main.bounds.width
        default:
            break
        }
    }
    
    // MARK: - Private API -
    // MARK: Setup Subviews
    
    private func setupSubviews() {
        backgroundColor = .black
        
        addSubview(stackView)
        stackView.addArrangedSubview(primaryView)
        primaryView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(secondaryView)
        secondaryView.addArrangedSubview(infoTableView)
        
        secondaryViewHeightConstraint = secondaryView.heightAnchor.constraint(equalToConstant: 0)
        secondaryViewWidthConstraint = secondaryView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            secondaryViewHeightConstraint,
            secondaryViewWidthConstraint
        ])
    }
}
