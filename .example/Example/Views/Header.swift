//
//  Header.swift
//  Example
//
//  Created by Lorenzo Toscani De Col on 17/07/2020.
//

import UIKit

class Header: UIView {
	
	private lazy var vStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [lineView, titleLabel])
		stack.axis = .vertical
		stack.distribution = .equalCentering
		stack.alignment = .center
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private lazy var lineView: UIView = {
		let line = UIView(frame: .zero)
		line.widthAnchor.constraint(equalToConstant: 100).isActive = true
		line.heightAnchor.constraint(equalToConstant: 4).isActive = true
		line.backgroundColor = UIColor.black.withAlphaComponent(0.3)
		line.layer.cornerRadius = 2
		line.layer.masksToBounds = true
		return line
	}()
	private lazy var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .darkText
		label.text = "Title"
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		return label
	}()
	
	init() {
		super.init(frame: .zero)
		
		addSubview(vStack)
		vStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		vStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		vStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
		vStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
