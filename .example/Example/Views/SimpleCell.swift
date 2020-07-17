//
//  SimpleCell.swift
//  Example
//
//  Created by Lorenzo Toscani De Col on 14/07/2020.
//

import UIKit

class SimpleCell: UITableViewCell {
	
	private let padding: CGFloat = 16
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = .darkText
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	private func commonInit() {
		addSubview(titleLabel)
		
		titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
		titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
		titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
}

extension SimpleCell {
	func setup(with text: String) {
		titleLabel.text = text
		titleLabel.sizeToFit()
	}
}
