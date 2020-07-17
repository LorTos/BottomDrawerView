//
//  Cell+Extension.swift
//  Example
//
//  Created by Lorenzo Toscani De Col on 14/07/2020.
//

import UIKit

extension UITableViewCell {
	static var defaultReuseId: String {
		String(describing: self)
	}
}
extension UICollectionViewCell {
	static var defaultReuseId: String {
		String(describing: self)
	}
}
