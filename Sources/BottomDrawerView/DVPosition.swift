//
//  DVPosition.swift
//  BottomDrawerView
//
//  Created by Lorenzo Toscani De Col on 23/06/2020.
//  Copyright © 2020 Lorenzo Toscani De Col. All rights reserved.
//

import Foundation
import CoreGraphics

public struct DVPosition {
	let percent: CGFloat
	
	public init(_ value: CGFloat) {
		percent = value
	}
}

extension DVPosition: Equatable, Comparable, Hashable {
	public static func < (lhs: DVPosition, rhs: DVPosition) -> Bool {
		return lhs.percent < rhs.percent
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(percent)
	}
}

extension DVPosition {
	static let defaultExpanded = DVPosition(0.9)
	static let defaultPartial = DVPosition(0.45)
	static let defaultCollapsed = DVPosition(0.2)
}

