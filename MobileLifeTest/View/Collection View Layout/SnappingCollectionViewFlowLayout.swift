//
//  SnappingCollectionViewFlowLayout.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import UIKit

class SnappingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let screenSize = collectionView!.bounds.size
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: screenSize.width, height: screenSize.height)
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        var closestLayoutAttributes: UICollectionViewLayoutAttributes!
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let proposedOffsetCenterX = proposedContentOffset.x + (screenSize.width / 2.0)
            if closestLayoutAttributes == nil
                || abs(layoutAttributes.center.x - proposedOffsetCenterX) < abs(closestLayoutAttributes.center.x - proposedOffsetCenterX){
                closestLayoutAttributes = layoutAttributes
            }
        })
        return CGPoint(x: closestLayoutAttributes.center.x - (screenSize.width / 2.0), y: proposedContentOffset.y)
    }
}
