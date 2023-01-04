//
//  SnappingCollectionViewFlowLayout.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import UIKit

class SnappingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Properties -
    // MARK: Private
    
    private var visibleIndexPath: IndexPath?
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
    }
    
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        super.prepare(forAnimatedBoundsChange: oldBounds)
        
        visibleIndexPath = collectionView?.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row })[1]
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let visibleIndexPath = visibleIndexPath,
              let attributes = layoutAttributesForItem(at: visibleIndexPath) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        var screenWidth: CGFloat
        let currentOrientation = UIDevice.current.orientation
        if currentOrientation == .landscapeLeft || currentOrientation == .landscapeRight {
            screenWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        }
        else {
            screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        }
       
        let widthDifference = screenWidth - attributes.size.width
        return CGPoint(x: attributes.frame.origin.x - (widthDifference / 2.0), y: proposedContentOffset.y)
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
    
    override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        visibleIndexPath = nil
    }
}
