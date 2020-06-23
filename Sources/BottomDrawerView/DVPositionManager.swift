//
//  DVPositionManager.swift
//  BottomDrawerProject
//
//  Created by Lorenzo Toscani De Col on 15/03/2019.
//  Copyright © 2019 Lorenzo Toscani De Col. All rights reserved.
//

import UIKit

class DVPositionManager {
	/**
	A CGFloat value that indicates draggable view height, so that it clears the bottom of the view.
	*/
	private var dragViewOffset: CGFloat
	
	var maxMovement: CGFloat {
		let maxHeight = frame(forPosition: supportedPositions.max() ?? DVPosition.defaultExpanded).height
		let minHeight = frame(forPosition: supportedPositions.min() ?? DVPosition.defaultCollapsed).height
		return abs(maxHeight -  minHeight)
	}
	
	/**

	*/
	var supportedPositions: Set<DVPosition> = [DVPosition.defaultExpanded, DVPosition.defaultPartial, DVPosition.defaultCollapsed]
	
	/**
	A Boolean value that determines whether on the *.collapsed* position the view is completely hidden.
	
	The default value for this parameter is **false**. If set to true, the *bottomOffset* parameter will be ignored.
	*/
	
	private var screenHeight: CGFloat { UIScreen.main.bounds.height }
	private var screenWidth: CGFloat { UIScreen.main.bounds.width }
	/**
	A CGFloat value indicating the height of the view.
	*/
	var totalHeight: CGFloat {
		switch supportedPositions.max() ?? DVPosition.defaultExpanded {
		case .expanded(let p), .partial(let p), .collapsed(let p):
			return screenHeight / p
		}
	}
	
	/**
	Indicates the current Position of the view.
	
	Possible values are:
	- **.expanded**
	- **.partial**
	- **.collapsed**
	*/
	var currentPosition: DVPosition = DVPosition.defaultExpanded
	
	init(interactiveViewHeight: CGFloat) {
		dragViewOffset = interactiveViewHeight
	}
	
	/**
	Calculates the frame of the view in a certain position.
	
	- Parameter position: The position of the frame you want to get.
	- Returns: A CGRect indicating the frame of the view in that position.
	*/
	func frame(forPosition position: DVPosition) -> CGRect {
		CGRect(origin: CGPoint(x: 0, y: referencePointY(forPosition: position)),
				 size: CGSize(width: screenWidth, height: totalHeight))
	}
	
	func referencePointY(forPosition position: DVPosition) -> CGFloat {
		switch position {
		case .expanded(let p), .partial(let p), .collapsed(let p):
			return screenHeight - (screenHeight * p)
		}
	}
	
	static func height(for position: DVPosition) -> CGFloat {
		switch position {
		case .expanded(let percent), .collapsed(let percent), .partial(let percent):
			return UIScreen.main.bounds.height * percent
		}
	}
	
	/**
	Calculates the closest Position to a certain point.
	
	- Parameter point: The point from which you want to find the position.
	- Returns: The **Position** closest to the point.
	*/
	func closestPosition(fromPoint point: CGPoint) -> DVPosition {
		var closest: DVPosition?
		supportedPositions.forEach {
			if let currentClosest = closest {
				let current = abs(point.y - referencePointY(forPosition: currentClosest))
				let new = abs(point.y - referencePointY(forPosition: $0))
				if new < current {
					closest = $0
				}
			} else {
				closest = $0
			}
		}
		return closest ?? DVPosition.defaultExpanded
	}
}
