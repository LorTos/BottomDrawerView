//
//  DrawerView.swift
//  BottomDrawerProject
//
//  Created by Lorenzo Toscani De Col on 15/03/2019.
//  Copyright © 2019 Lorenzo Toscani De Col. All rights reserved.
//

import UIKit

public protocol DraggableViewDelegate: class {
	func draggableView(_ draggableView: DrawerView, didFinishUpdatingPosition position: DVPosition)
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
	private(set) var interactiveView: UIView?
	private(set) var containerView: DVContainerView?
	
	private(set) var panGesture: UIPanGestureRecognizer!
	private(set) var positionManager: DVPositionManager?
	
	public var currentPosition: DVPosition? {
		return positionManager?.currentPosition
	}
	
	// MARK: - Properties
	private(set) var draggableViewHeight: CGFloat = 50
	let lineWidth: CGFloat = 32
	
	public var isDragEnabled: Bool = true {
		didSet {
			panGesture.isEnabled = isDragEnabled
		}
	}
	public var supportedPositions: Set<DVPosition> = [DVPosition.defaultExpanded, DVPosition.defaultPartial, DVPosition.defaultCollapsed] {
		didSet {
			positionManager?.supportedPositions = supportedPositions
		}
	}
	/// Sets corner radius of draggable view. Defaults to **6**
	public var cornerRadius: CGFloat = 6 {
		didSet {
			layer.cornerRadius = cornerRadius
			interactiveView?.layer.cornerRadius = cornerRadius
		}
	}
	public var lineTintColor: UIColor = .lightGray {
		didSet {
			lineView.backgroundColor = lineTintColor
		}
	}
	public var interactiveViewBorderWidth: CGFloat {
		get {
			interactiveView?.layer.borderWidth ?? 0
		}
		set {
			interactiveView?.layer.borderWidth = newValue
		}
	}
	public var interactiveViewBorderColor: CGColor? {
		get {
			interactiveView?.layer.borderColor
		}
		set {
			interactiveView?.layer.borderColor = newValue
		}
	}
	override public var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
			containerView?.backgroundColor = backgroundColor
		}
	}
	
	// MARK: - Delegate
	weak public var delegate: DraggableViewDelegate?
	
	// MARK: - init() and initial setup
	public init(containing childController: UIViewController,
					inside parentController: UIViewController,
					draggableViewHeight: CGFloat = 50)
	{
		super.init(frame: CGRect.zero)
		commonInit(draggableViewHeight: draggableViewHeight, childView: childController.view, parentController: parentController)
		parentController.addChild(childController)
		childController.didMove(toParent: parentController)
	}
	public init(containing childView: UIView,
					inside parentController: UIViewController,
					draggableViewHeight: CGFloat = 50)
	{
		super.init(frame: CGRect.zero)
		commonInit(draggableViewHeight: draggableViewHeight, childView: childView, parentController: parentController)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(:coder) not implemented")
	}
	private func commonInit(draggableViewHeight: CGFloat, childView: UIView, parentController: UIViewController) {
		self.draggableViewHeight = draggableViewHeight
		let totalHeight = DVPositionManager.height(for: supportedPositions.max() ?? DVPosition.defaultExpanded)
		positionManager = DVPositionManager(interactiveViewHeight: draggableViewHeight)
		interactiveView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: parentController.view.bounds.width, height: draggableViewHeight)))
		containerView = DVContainerView(containing: childView, height: totalHeight - draggableViewHeight, topInset: draggableViewHeight)
		
		setupInteractiveView()
		setupContainerView()
		
		parentController.view.addSubview(self)
		leadingAnchor.constraint(equalTo: parentController.view.leadingAnchor).isActive = true
		trailingAnchor.constraint(equalTo: parentController.view.trailingAnchor).isActive = true
		
		setRoundedCornersAndShadow()
		setPosition(to: supportedPositions.max() ?? DVPosition.defaultExpanded, animated: false)
		backgroundColor = .white
		addLandscapeNotification()
	}
	
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	private func addLandscapeNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(didChangeDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	private func setRoundedCornersAndShadow() {
		layer.cornerRadius = cornerRadius
		layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
		layer.masksToBounds = false
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: -2)
		layer.shadowRadius = 5
		layer.shadowOpacity = 0.1
	}
	
	func setupInteractiveView() {
		guard let interactiveView = interactiveView else { return }
		addSubview(interactiveView)
		
		interactiveView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
		interactiveView.layer.borderWidth = 0.5
		interactiveView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
		interactiveView.layer.cornerRadius = cornerRadius
		
		interactiveView.translatesAutoresizingMaskIntoConstraints = false
		interactiveView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		interactiveView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		interactiveView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		interactiveView.heightAnchor.constraint(equalToConstant: draggableViewHeight).isActive = true
		
		func setupLineView() {
			interactiveView.addSubview(lineView)
			lineView.translatesAutoresizingMaskIntoConstraints = false
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
		guard let containerView = containerView, let interactiveView = interactiveView else { return }
		addSubview(containerView)
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.topAnchor.constraint(equalTo: interactiveView.bottomAnchor).isActive = true
		containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
		containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
	}
	
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
	}
	
	@objc private func didChangeDeviceOrientation() {
		setPosition(to: currentPosition ?? DVPosition.defaultExpanded, animated: false)
	}
	
	// MARK: - Functions
	public func setPosition(to position: DVPosition, animated: Bool, completion: (() -> Void)? = nil) {
		guard let positionManager = positionManager else { return }
		
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
		guard let positionManager = positionManager, let currentPosition = currentPosition else { return }
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
			let max = supportedPositions.max()
			let min = supportedPositions.min()
			if velocity > velocityThreshold {
				setPosition(to: min ?? DVPosition.defaultCollapsed, animated: true)
			} else if velocity < -velocityThreshold {
				setPosition(to: max ?? DVPosition.defaultExpanded, animated: true)
			} else {
				switch currentPosition {
				case .partial:
					if velocity > slowVelocityThreshold {
						setPosition(to: min ?? DVPosition.defaultCollapsed, animated: true)
					} else if velocity < -slowVelocityThreshold {
						setPosition(to: max ?? DVPosition.defaultExpanded, animated: true)
					} else {
						setPosition(to: positionManager.closestPosition(fromPoint: frame.origin), animated: true)
					}
				case .collapsed:
					if velocity < -slowVelocityThreshold {
						let partial = supportedPositions.first(where: { $0 == .partial(/* Not important for equality */0) })
						setPosition(to: partial ?? supportedPositions.max() ?? DVPosition.defaultExpanded, animated: true)
					} else {
						setPosition(to: positionManager.closestPosition(fromPoint: frame.origin), animated: true)
					}
				case .expanded:
					if velocity > slowVelocityThreshold {
						let partial = supportedPositions.first(where: { $0 == .partial(/* Not important for equality */0) })
						setPosition(to: partial ?? supportedPositions.min() ?? DVPosition.defaultCollapsed, animated: true)
					} else {
						setPosition(to: positionManager.closestPosition(fromPoint: frame.origin), animated: true)
					}
				}
			}
		default: return
		}
	}
}
