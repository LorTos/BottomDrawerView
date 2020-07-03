//
//  File.swift
//  
//
//  Created by Lorenzo Toscani De Col on 03/07/2020.
//

import UIKit

protocol DVInteractiveViewDelegate: class {
	func didPan(_ gesture: UIPanGestureRecognizer)
}

public enum InteractiveViewChildAlignment {
	case left(margin: CGFloat),
		  center,
		  right(margin: CGFloat),
		  fill
}

class DVInteractiveView: UIView {
	
	private(set) var panGesture: UIPanGestureRecognizer!
	
	var isDragEnabled: Bool = true {
		didSet {
			panGesture.isEnabled = isDragEnabled
		}
	}
	
	weak var delegate: DVInteractiveViewDelegate?
	
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
		
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(isPanning(_:)))
		addGestureRecognizer(panGesture)
	}
	
	@objc private func isPanning(_ gesture: UIPanGestureRecognizer) {
		delegate?.didPan(gesture)
	}
	
	func addChildView(_ view: UIView, alignment: InteractiveViewChildAlignment) {
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setContentHuggingPriority(.defaultHigh, for: .vertical)
		view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		addSubview(view)
		
		var constraints: [NSLayoutConstraint] = []
		let vCenter = view.centerYAnchor.constraint(equalTo: centerYAnchor)
		vCenter.priority = .required
		let top = view.topAnchor.constraint(greaterThanOrEqualTo: topAnchor)
		top.priority = .defaultHigh
		let bottom = view.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor)
		bottom.priority = .defaultHigh
		constraints += [vCenter, top, bottom]
		switch alignment {
		case .left(let margin):
			let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin)
			leading.priority = .required
			let trailing = view.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -margin)
			trailing.priority = .defaultHigh
			constraints += [leading, trailing]
		case .center:
			let hCenter = view.centerXAnchor.constraint(equalTo: centerXAnchor)
			hCenter.priority = .required
			let width = view.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.6)
			width.priority = .defaultHigh
			constraints += [hCenter, width]
		case .right(let margin):
			let leading = view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: margin)
			leading.priority = .defaultHigh
			let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin)
			trailing.priority = .required
			constraints += [leading, trailing]
		case .fill:
			let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
			leading.priority = .required
			let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor)
			trailing.priority = .required
			constraints += [leading, trailing]
		}
		constraints.forEach { $0.isActive = true }
		addConstraints(constraints)
	}
}


