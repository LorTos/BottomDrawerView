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
	func draggableView(_ draggableView: DrawerView, didDragByAmount verticalDragAmount: CGFloat)
}

public class DrawerView: UIView {
	
	// MARK: - Variables
	
	private(set) var positionManager: DVPositionManager?
	private(set) var interactiveView: DVInteractiveView?
	private(set) var containerView: DVContainerView?
	
	public var currentPosition: DVPosition? {
		return positionManager?.currentPosition
	}
	
	private lazy var backgroundPanGesture: UIPanGestureRecognizer = {
		return UIPanGestureRecognizer(target: self, action: #selector(panned))
	}()
	
	// MARK: - Properties
	public var supportedPositions: Set<DVPosition> = [DVPosition.defaultExpanded, DVPosition.defaultPartial, DVPosition.defaultCollapsed] {
		didSet {
			positionManager?.supportedPositions = supportedPositions
			setPosition(to: supportedPositions.min() ?? DVPosition.defaultCollapsed, animated: false)
		}
	}
	
	public var cornerRadius: CGFloat = 6 {
		didSet {
			layer.cornerRadius = cornerRadius
			interactiveView?.layer.cornerRadius = cornerRadius
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
		setupPositionManager(height: draggableViewHeight)
		setupInteractiveView(frame: CGRect(origin: .zero, size: CGSize(width: parentController.view.bounds.width, height: draggableViewHeight)))
		setupContainerView(child: childView)
		
		parentController.view.addSubview(self)
		leadingAnchor.constraint(equalTo: parentController.view.leadingAnchor).isActive = true
		trailingAnchor.constraint(equalTo: parentController.view.trailingAnchor).isActive = true
		
		setRoundedCornersAndShadow()
		setPosition(to: supportedPositions.min() ?? DVPosition.defaultCollapsed, animated: false)
		backgroundColor = .white
		
		addGestureRecognizer(backgroundPanGesture)
		NotificationCenter.default.addObserver(self, selector: #selector(didChangeDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	private func setupPositionManager(height: CGFloat) {
		positionManager = DVPositionManager(interactiveViewHeight: height)
		positionManager?.delegate = self
	}
	
	private func setupInteractiveView(frame: CGRect) {
		interactiveView = DVInteractiveView(frame: .zero)
		
		guard let interactiveView = interactiveView else { return }
		interactiveView.delegate = positionManager
		
		addSubview(interactiveView)
		interactiveView.translatesAutoresizingMaskIntoConstraints = false
		interactiveView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		interactiveView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		interactiveView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		interactiveView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
	}

	private func setupContainerView(child: UIView) {
		containerView = DVContainerView(containing: child)
		
		guard let containerView = containerView, let interactiveView = interactiveView else { return }
		
		addSubview(containerView)
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.topAnchor.constraint(equalTo: interactiveView.bottomAnchor).isActive = true
		containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
		containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
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
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
	}
	
	@objc private func didChangeDeviceOrientation() {
		setPosition(to: currentPosition ?? DVPosition.defaultExpanded, animated: false)
	}
	
	// MARK: - Functions
	private func setPosition(to position: DVPosition, animated: Bool, completion: (() -> Void)? = nil) {
		guard let positionManager = positionManager else { return }
		
		let oldFrame = positionManager.frame(forPosition: positionManager.currentPosition)
		positionManager.currentPosition = position
		let fullFrame = positionManager.frame(forPosition: position)
		let diff = abs(oldFrame.height - fullFrame.height)
		if animated {
			let diff = Double((diff / positionManager.maxMovement) / 2)
			let duration = min(max(0.3, diff), 0.6)
			UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
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
	
	public func expand(animated: Bool = true) {
		setPosition(to: supportedPositions.max() ?? DVPosition.defaultExpanded, animated: animated)
	}
	
	public func collapse(animated: Bool = true) {
		setPosition(to: supportedPositions.min() ?? DVPosition.defaultCollapsed, animated: animated)
	}
	
	public func addSubviewToInteractiveView(_ subview: UIView, aligned: InteractiveViewChildAlignment) {
		interactiveView?.addChildView(subview, alignment: aligned)
	}
	
	@objc private func panned(_ sender: UIPanGestureRecognizer) {
		positionManager?.didPan(sender)
	}
}

extension DrawerView: DVPositionManagerDelegate {
	func updateDrawerFrame(byAmount amount: CGFloat, gesture: UIPanGestureRecognizer) {
		guard let positionManager = positionManager else { return }
		let transform = CGAffineTransform(translationX: 0, y: amount)
		let newFrame = frame.applying(transform)
		let screenHeight = UIScreen.main.bounds.height
		let isInsideLimit = newFrame.origin.y >= screenHeight - positionManager.totalHeight
		if isInsideLimit {
			frame = newFrame
			gesture.setTranslation(.zero, in: self)
			delegate?.draggableView(self, didDragByAmount: amount)
		}
	}
	
	func updateDrawerPosition(_ position: DVPosition) {
		setPosition(to: position, animated: true)
	}
}
