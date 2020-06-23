//
//  DVPosition.swift
//  BottomDrawerView
//
//  Created by Lorenzo Toscani De Col on 23/06/2020.
//  Copyright © 2020 Lorenzo Toscani De Col. All rights reserved.
//

import Foundation
import CoreGraphics

public enum DVPosition: Equatable, Comparable, Hashable {
	case expanded(CGFloat), partial(CGFloat), collapsed(CGFloat)
	
	public static func < (lhs: DVPosition, rhs: DVPosition) -> Bool {
		switch (lhs, rhs) {
		case (.collapsed, .partial), (.partial, .expanded), (.collapsed, .expanded): return true
		case (.partial, .collapsed), (.expanded, .collapsed), (.expanded, .partial): return false
		default:
			return false
		}
	}
	public static func == (lhs: DVPosition, rhs: DVPosition) -> Bool {
		switch (lhs, rhs) {
		case (.collapsed, .collapsed), (.partial, .partial), (.expanded, .expanded): return true
		default: return false
		}
	}
	
	public static var defaultExpanded: DVPosition {
		return .expanded(0.9)
	}
	public static var defaultCollapsed: DVPosition {
		return .collapsed(0.1)
	}
	public static var defaultPartial: DVPosition {
		return .expanded(0.45)
	}
}


