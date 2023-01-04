//
//  Coordinator.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 04/01/2023.
//

import Foundation
import UIKit

enum Coordinator {
    static var navigationController: UINavigationController!

    static func navigateToImageDetail(picture: Picture) {
        let viewModel = ImageDetailViewModel(picture: picture)
        let imageDetailViewController = ImageDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(imageDetailViewController, animated: true)
    }
}
