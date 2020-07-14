//
//  DVHeaderView.swift
//  BottomDrawerProject
//
//  Created by Lorenzo Toscani De Col on 03/07/2020.
//

import UIKit

protocol DVHeaderViewDelegate: class {
	func didPan(_ gesture: UIPanGestureRecognizer)
	func didTapOnHeader(_ gesture: UITapGestureRecognizer)
}

public enum HeaderViewChildAlignment {
	case 	centerLeft(leftMargin: CGFloat),
			topLeft(leftMargin: CGFloat),
			bottomLeft(leftMargin: CGFloat),
			center,
			centerRight(rightMargin: CGFloat),
			topRight(rightMargin: CGFloat),
			bottomRight(rightMargin: CGFloat),
			fill(horizontalMargin: CGFloat)
}

class DVHeaderView: UIView {
	
	private(set) var panGesture: UIPanGestureRecognizer!
	private(set) var tapGesture: UITapGestureRecognizer!
	
	var isDragEnabled: Bool = true {
		didSet {
			panGesture.isEnabled = isDragEnabled
		}
	}
	var defaultMargin: CGFloat { 10 }
	
	weak var delegate: DVHeaderViewDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	private func commonInit() {
		translatesAutoresizingMaskIntoConstraints = false
		
		layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
		
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(isPanning))
		tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
		addGestureRecognizer(panGesture)
		addGestureRecognizer(tapGesture)
	}
	
	@objc private func isPanning(_ gesture: UIPanGestureRecognizer) {
		delegate?.didPan(gesture)
	}
	
	@objc private func tapped(_ gesture: UITapGestureRecognizer) {
		delegate?.didTapOnHeader(gesture)
	}
	
	func addChildView(_ view: UIView, alignment: HeaderViewChildAlignment) {
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setContentHuggingPriority(.defaultHigh, for: .vertical)
		view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		addSubview(view)
		
		var constraints: [NSLayoutConstraint] = []
		let vCenter = view.centerYAnchor.constraint(equalTo: centerYAnchor)
		vCenter.priority = .required
		let hCenter = view.centerXAnchor.constraint(equalTo: centerXAnchor)
		hCenter.priority = .required
		let defaultTop = view.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: defaultMargin)
		defaultTop.priority = .defaultHigh
		let defaultBottom = view.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -defaultMargin)
		defaultBottom.priority = .defaultHigh
		switch alignment {
		case .centerLeft(let margin):
			let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin)
			leading.priority = .required
			constraints += [leading, vCenter, defaultTop, defaultBottom]
		case .topLeft(let margin):
			let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin)
			leading.priority = .required
			let top = view.topAnchor.constraint(equalTo: topAnchor, constant: defaultMargin)
			top.priority = .required
			constraints += [leading, top, defaultBottom]
		case .bottomLeft(let margin):
			let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin)
			leading.priority = .required
			let bottom = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -defaultMargin)
			bottom.priority = .required
			constraints += [leading, defaultTop, bottom]
		case .center:
			let width = view.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.6)
			width.priority = .defaultHigh
			constraints += [hCenter, width, vCenter, defaultTop, defaultBottom]
		case .centerRight(let margin):
			let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin)
			trailing.priority = .required
			constraints += [trailing, vCenter, defaultBottom, defaultTop]
		case .topRight(let margin):
			let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin)
			trailing.priority = .required
			let top = view.topAnchor.constraint(equalTo: topAnchor, constant: defaultMargin)
			top.priority = .required
			constraints += [trailing, top, defaultBottom]
		case .bottomRight(let margin):
			let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin)
			trailing.priority = .required
			let bottom = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -defaultMargin)
			bottom.priority = .required
			constraints += [trailing, bottom, defaultTop]
		case .fill:
			let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
			leading.priority = .required
			let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor)
			trailing.priority = .required
			constraints += [leading, trailing, defaultTop, defaultBottom, vCenter]
		}
		constraints.forEach { $0.isActive = true }
		addConstraints(constraints)
	}
}


