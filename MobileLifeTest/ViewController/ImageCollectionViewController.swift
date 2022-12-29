//
//  ViewController.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    
    // MARK: - Properties -
    // MARK: Internal
    
    var rootView: ImageCollectionView {
        return view as! ImageCollectionView
    }
    
    var viewModel: ImageCollectionViewModelType = ImageCollectionViewModel()
    
    // MARK: - Controller Lifecycle -
    
    override func loadView() {
        view = ImageCollectionView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: .zero)
    }
    
    
}

