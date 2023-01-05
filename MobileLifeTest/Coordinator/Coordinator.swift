//
//  Coordinator.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 04/01/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum Coordinator {
    static var navigationController: UINavigationController!

    static func navigateToImageDetail(selectedPictureIndex: Int, pictures: BehaviorRelay<[Picture]>) {
        let viewModel = ImageDetailViewModel(selectedPictureIndex: selectedPictureIndex, pictures: pictures)
        let imageDetailViewController = ImageDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(imageDetailViewController, animated: true)
    }
}
