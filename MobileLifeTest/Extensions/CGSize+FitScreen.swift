//
//  CGSize+FitScreen.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 30/12/2022.
//

import Foundation
import UIKit

extension CGSize {
    func fittingInScreen(scale: CGFloat = 1.0) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let maxCellWidth = screenWidth * 0.75
        let maxCellHeight = screenHeight * 0.75
        let pictureWidth = width
        let pictureHeight = height
        
        var resizedHeight: CGFloat
        var resizedWidth: CGFloat
        
        if pictureHeight * maxCellWidth / pictureWidth < maxCellHeight {
            resizedWidth = maxCellWidth
            resizedHeight = pictureHeight * maxCellWidth / pictureWidth
        }
        else {
            resizedWidth = pictureWidth * maxCellHeight / pictureHeight
            resizedHeight = maxCellHeight
        }
        
        return CGSize(width: resizedWidth * scale, height: resizedHeight * scale)
    }
}
