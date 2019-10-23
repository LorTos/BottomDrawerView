//
//  DVPositionManager.swift
//  BottomDrawerProject
//
//  Created by Lorenzo Toscani De Col on 15/03/2019.
//  Copyright © 2019 Lorenzo Toscani De Col. All rights reserved.
//

import UIKit

public class DVPositionManager {
    
    public enum Position {
        case expanded, partial, collapsed
    }
    
    /**
     A CGFloat value that indicates the distance from the status bar.
     
     The default value for this parameter is **0**.
    */
    var topOffset: CGFloat
    
    /**
     A CGFloat value that indicates the distance from the bottom safe area.
     
     The default value for this parameter is **0**.
    */
    var bottomOffset: CGFloat
    
    /**
     A CGFloat value that indicates draggable view height, so that it clears the bottom of the view.
    */
    private var dragViewOffset: CGFloat
    
    /**
     A CGFloat value that sets the height of the entire view.
     
     The default value for this parameter is **nil**. If set, the *topOffset* parameter will be ignored.
    */
    var customHeight: CGFloat?
    
    /**
     A Boolean value that determines whether the partial position is enabled or not.
     
     The default value for this parameter is **true**.
    */
    var isPartialPositionEnabled = true
    
    /**
     A Boolean value that determines whether on the *.collapsed* position the view is completely hidden.
     
     The default value for this parameter is **false**. If set to true, the *bottomOffset* parameter will be ignored.
    */
    var hidesOnCollapse = false
    
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    private var bottomSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    /**
     A CGFloat value indicating the height of the view.
    */
    var totalHeight: CGFloat {
        if let customHeight = customHeight {
            return customHeight
        } else {
            return screenHeight - UIApplication.shared.statusBarFrame.height - topOffset
        }
    }
    
    /**
     Indicates the current Position of the view.
     
     Possible values are:
        - **.expanded**
        - **.partial**
        - **.collapsed**
    */
    var currentPosition: Position = .collapsed
    
    init(topOffset: CGFloat = 0, bottomOffset: CGFloat = 0, interactiveViewHeight: CGFloat) {
        dragViewOffset = interactiveViewHeight
        self.topOffset = topOffset
        self.bottomOffset = bottomOffset
    }
    
    /**
     Calculates the frame of the view in a certain position.
     
     - Parameter position: The position of the frame you want to get.
     - Returns: A CGRect indicating the frame of the view in that position.
    */
    func frame(forPosition position: Position) -> CGRect {
        let frameSize = CGSize(width: screenWidth, height: totalHeight)
        var yPosition: CGFloat
        switch position {
        case .expanded:
            yPosition = screenHeight - frameSize.height
        case .partial:
            yPosition = isPartialPositionEnabled ? screenHeight - (frameSize.height / 2) : screenHeight - frameSize.height
        case .collapsed:
            if hidesOnCollapse {
                yPosition = screenHeight
            } else {
                yPosition = screenHeight - bottomOffset - bottomSafeArea - dragViewOffset
            }
        }
        return CGRect(origin: CGPoint(x: 0, y: yPosition), size: frameSize)
    }
    
    /**
     Calculates the closest Position to a certain point.
     
     - Parameter point: The point from which you want to find the position.
     - Returns: The **Position** closest to the point.
    */
    func closestPosition(fromPoint point: CGPoint) -> Position {
        func referencePointY(forState state: DVPositionManager.Position) -> CGFloat {
            switch state {
            case .expanded:
                return screenHeight - totalHeight
            case .partial:
                return screenHeight - (totalHeight / 2)
            case .collapsed:
                return screenHeight - bottomOffset - bottomSafeArea
            }
        }
        
        var minDistance: CGFloat
        let distanceFromExpanded: CGFloat = abs(point.y - referencePointY(forState: .expanded))
        let distanceFromCollapsed: CGFloat = abs(point.y - referencePointY(forState: .collapsed))
        var distanceFromPartial: CGFloat?
        if isPartialPositionEnabled {
            distanceFromPartial = abs(point.y - referencePointY(forState: .partial))
            minDistance = min(distanceFromPartial!, distanceFromCollapsed, distanceFromExpanded)
        } else {
            minDistance = min(distanceFromCollapsed, distanceFromExpanded)
        }
        
        
        switch minDistance {
        case distanceFromExpanded: return .expanded
        case distanceFromCollapsed: return .collapsed
        case distanceFromPartial: return .partial
        default: return .collapsed
        }
    }
}
