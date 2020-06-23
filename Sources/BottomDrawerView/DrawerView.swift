//
//  DrawerView.swift
//  BottomDrawerProject
//
//  Created by Lorenzo Toscani De Col on 15/03/2019.
//  Copyright © 2019 Lorenzo Toscani De Col. All rights reserved.
//

import UIKit

public protocol DraggableViewDelegate: class {
	func draggableView(_ draggableView: DrawerView, didFinishUpdatingPosition position: DVPositionManager.Position)
}

public class DrawerView: UIView {
	
	// MARK: - Variables
	lazy var lineView: UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: lineWidth, height: 2))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 1
		view.layer.masksToBounds = true
		view.backgroundColor = lineTintColor
		return view
	}()
	private(set) var interactiveView: UIView
	private(set) var containerView: DVContainerView
	
	private(set) var panGesture: UIPanGestureRecognizer!
	private(set) var positionManager: DVPositionManager
	public var currentPosition: DVPositionManager.Position {
		return positionManager.currentPosition
	}
	
	// MARK: - Properties
	private(set) var draggableViewHeight: CGFloat
	let lineWidth: CGFloat = 32
	
	public var isDragEnabled: Bool = true {
		didSet {
			panGesture.isEnabled = isDragEnabled
		}
	}
	public var supportedPositions: Set<DVPositionManager.Position> = [.expanded, .partial, .collapsed] {
		didSet {
			positionManager.isPartialPositionEnabled = supportedPositions.contains(.partial)
		}
	}
	public var topOffset: CGFloat {
		get {
			return positionManager.topOffset
		}
		set {
			positionManager.topOffset = newValue
		}
	}
	public var bottomOffset: CGFloat {
		get {
			positionManager.bottomOffset
		}
		set {
			positionManager.bottomOffset = newValue
		}
	}
	/// Sets corner radius of draggable view. Defaults to **6**
	public var cornerRadius: CGFloat = 6 {
		didSet {
			layer.cornerRadius = cornerRadius
			interactiveView.layer.cornerRadius = cornerRadius
		}
	}
	public var lineTintColor: UIColor = .lightGray {
		didSet {
			lineView.backgroundColor = lineTintColor
		}
	}
	public var interactiveViewBorderWidth: CGFloat {
		get {
			interactiveView.layer.borderWidth
		}
		set {
			interactiveView.layer.borderWidth = newValue
		}
	}
	public var interactiveViewBorderColor: CGColor? {
		get {
			interactiveView.layer.borderColor
		}
		set {
			interactiveView.layer.borderColor = newValue
		}
	}
	override public var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
			containerView.backgroundColor = backgroundColor
		}
	}
	
	// MARK: - Delegate
	weak public var delegate: DraggableViewDelegate?
	
	// MARK: - init() and initial setup
	public init(containing childController: UIViewController,
					inside parentController: UIViewController,
					totalHeight: CGFloat = UIScreen.main.bounds.height * 0.8,
					draggableViewHeight: CGFloat = 44)
	{
		positionManager = DVPositionManager(interactiveViewHeight: draggableViewHeight)
		interactiveView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: parentController.view.bounds.width, height: draggableViewHeight)))
		containerView = DVContainerView(containing: childController.view, height: totalHeight - draggableViewHeight, topInset: draggableViewHeight)
		self.draggableViewHeight = draggableViewHeight
		super.init(frame: CGRect(origin: .zero, size: CGSize(width: parentController.view.bounds.width, height: positionManager.totalHeight)))
		positionManager.customHeight = totalHeight
		self.bottomOffset = parentController.view.safeAreaInsets.bottom
		
		setupInteractiveView()
		setupContainerView()
		
		parentController.view.addSubview(self)
		heightAnchor.constraint(equalToConstant: frame.height).isActive = true
		leadingAnchor.constraint(equalTo: parentController.view.leadingAnchor).isActive = true
		trailingAnchor.constraint(equalTo: parentController.view.trailingAnchor).isActive = true
		bottomAnchor.constraint(equalTo: parentController.view.bottomAnchor, constant: 0).isActive = true
		parentController.addChild(childController)
		childController.didMove(toParent: parentController)
		
		setRoundedCornersAndShadow()
		setPosition(to: .expanded, animated: false)
		
		backgroundColor = .white
	}
	public init(containing childView: UIView,
					inside parentController: UIViewController,
					totalHeight: CGFloat = UIScreen.main.bounds.height * 0.8,
					draggableViewHeight: CGFloat = 44)
	{
		positionManager = DVPositionManager(interactiveViewHeight: draggableViewHeight)
		interactiveView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: parentController.view.bounds.width, height: draggableViewHeight)))
		containerView = DVContainerView(containing: childView, height: positionManager.totalHeight - draggableViewHeight, topInset: draggableViewHeight)
		self.draggableViewHeight = draggableViewHeight
		super.init(frame: CGRect(origin: .zero, size: CGSize(width: parentController.view.bounds.width, height: positionManager.totalHeight)))
		positionManager.customHeight = totalHeight
		self.bottomOffset = parentController.view.safeAreaInsets.bottom
		
		setupInteractiveView()
		setupContainerView()
		
		parentController.view.addSubview(self)
		heightAnchor.constraint(equalToConstant: frame.height).isActive = true
		leadingAnchor.constraint(equalTo: parentController.view.leadingAnchor).isActive = true
		trailingAnchor.constraint(equalTo: parentController.view.trailingAnchor).isActive = true
		bottomAnchor.constraint(equalTo: parentController.view.bottomAnchor, constant: 0).isActive = true
		
		setRoundedCornersAndShadow()
		
		setPosition(to: .expanded, animated: false)
		backgroundColor = .white
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(:coder) not implemented")
	}
	
	
	func setRoundedCornersAndShadow() {
		layer.cornerRadius = cornerRadius
		layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
		layer.masksToBounds = false
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: -2)
		layer.shadowRadius = 5
		layer.shadowOpacity = 0.1
	}
	
	func setupInteractiveView() {
		addSubview(interactiveView)
		
		interactiveView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
		interactiveView.layer.borderWidth = 0.5
		interactiveView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
		interactiveView.layer.cornerRadius = cornerRadius
		
		interactiveView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		interactiveView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		interactiveView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		interactiveView.heightAnchor.constraint(equalToConstant: draggableViewHeight).isActive = true
		
		func setupLineView() {
			interactiveView.addSubview(lineView)
			lineView.constraints.forEach({ lineView.removeConstraint($0) })
			constraints.forEach({
				if $0.firstItem === lineView || $0.secondItem === lineView {
					removeConstraint($0)
				}
			})
			lineView.centerXAnchor.constraint(equalTo: interactiveView.centerXAnchor).isActive = true
			lineView.centerYAnchor.constraint(equalTo: interactiveView.centerYAnchor).isActive = true
			lineView.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
			lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
		}
		setupLineView()
		
		func addPanGesture() {
			panGesture = UIPanGestureRecognizer(target: self, action: #selector(isPanning(_:)))
			interactiveView.addGestureRecognizer(panGesture)
		}
		addPanGesture()
	}
	
	func setupContainerView() {
		addSubview(containerView)
		containerView.topAnchor.constraint(equalTo: interactiveView.bottomAnchor).isActive = true
		containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
		containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
	}
	
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
	}
	
	// MARK: - Functions
	public func setPosition(to position: DVPositionManager.Position, animated: Bool, completion: (() -> Void)? = nil) {
		let oldFrame = positionManager.frame(forPosition: positionManager.currentPosition)
		positionManager.currentPosition = position
		let fullFrame = positionManager.frame(forPosition: position)
		let diff = abs(oldFrame.height - fullFrame.height)
		if animated {
			let diff = Double((diff / positionManager.maxMovement) / 2)
			let duration = min(max(0.3, diff), 0.6)
			UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				self.frame = fullFrame
			}) { _ in
				self.delegate?.draggableView(self, didFinishUpdatingPosition: position)
				completion?()
			}
		} else {
			frame = fullFrame
			delegate?.draggableView(self, didFinishUpdatingPosition: position)
			completion?()
		}
	}
	
	// MARK: - Pan gesture
	@objc private func isPanning(_ gesture: UIPanGestureRecognizer) {
		handlePan(gesture)
	}
	
	func handlePan(_ gesture: UIPanGestureRecognizer) {
		func applyTranslation(_ yTranslation: CGFloat) {
			let transform = CGAffineTransform(translationX: 0, y: yTranslation)
			let newFrame = frame.applying(transform)
			let screenHeight = UIScreen.main.bounds.height
			let isInsideLimit = newFrame.origin.y >= screenHeight - positionManager.totalHeight
			if isInsideLimit {
				frame = newFrame
				gesture.setTranslation(.zero, in: self)
			}
		}
		
		switch gesture.state {
		case .began, .changed:
			let translationAmount = gesture.translation(in: self).y
			applyTranslation(translationAmount)
		case .ended:
			let velocity = gesture.velocity(in: self).y
			let velocityThreshold: CGFloat = 2000
			let slowVelocityThreshold: CGFloat = 400
			if velocity > velocityThreshold {
				setPosition(to: .collapsed, animated: true)
			} else if velocity < -velocityThreshold {
				setPosition(to: .expanded, animated: true)
			} else {
				switch currentPosition {
				case .partial:
					if velocity > slowVelocityThreshold {
						setPosition(to: .collapsed, animated: true)
					} else if velocity < -slowVelocityThreshold {
						setPosition(to: .expanded, animated: true)
					} else {
						setPosition(to: positionManager.closestPosition(fromPoint: frame.origin), animated: true)
					}
				case .collapsed:
					if velocity < slowVelocityThreshold {
						setPosition(to: supportedPositions.contains(.partial) ? .partial : .expanded, animated: true)
					} else {
						setPosition(to: positionManager.closestPosition(fromPoint: frame.origin), animated: true)
					}
				case .expanded:
					if velocity > slowVelocityThreshold {
						setPosition(to: supportedPositions.contains(.partial) ? .partial : .collapsed, animated: true)
					} else {
						setPosition(to: positionManager.closestPosition(fromPoint: frame.origin), animated: true)
					}
				}
			}
		default: return
		}
	}
}
