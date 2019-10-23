//
//  BottomDrawerViewController.swift
//  BottomDrawerProject
//
//  Created by Lorenzo Toscani De Col on 30/09/2019.
//  Copyright © 2019 Lorenzo Toscani De Col. All rights reserved.
//

import UIKit

public class BottomDrawer: UIViewController {
    
    var dismissTapGesture: UITapGestureRecognizer!
    private(set) var drawerView: DrawerView!
    var didPresent = false
    
    convenience init(containingView childView: UIView, height: CGFloat) {
        self.init()
        
        drawerView = DrawerView(containing: childView, inside: self, totalHeight: height, draggableViewHeight: 44)
        commonDraggableViewSetup()
    }
    convenience init(containingViewController childViewController: UIViewController, height: CGFloat) {
        self.init()
        
        drawerView = DrawerView(containing: childViewController, inside: self, totalHeight: height, draggableViewHeight: 44)
        commonDraggableViewSetup()
    }
    func commonDraggableViewSetup() {
        drawerView.bottomOffset = tabBarController?.tabBar.bounds.height ?? 0
        drawerView.hidesOnCollapsedPosition = true
        drawerView.isPartialPositionEnabled = false
        drawerView.setPosition(to: .collapsed, animated: false)
        drawerView.backgroundColor = UIColor.white
        drawerView.delegate = self
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(collapseView))
        dismissTapGesture.delegate = self
        view.addGestureRecognizer(dismissTapGesture)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawerView.setPosition(to: .expanded, animated: true)
    }
    
    @objc func collapseView() {
        drawerView.setPosition(to: .collapsed, animated: true)
    }
}

extension BottomDrawer: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchIsInDrawer = touch.view?.isDescendant(of: drawerView) ?? false
        return !touchIsInDrawer
    }
}

extension BottomDrawer: DraggableViewDelegate {
    public func draggableView(_ draggableView: DrawerView, didFinishUpdatingPosition position: DVPositionManager.Position) {
        switch position {
        case .expanded:
            if !didPresent {
                didPresent = true
            }
        case .collapsed:
            if didPresent {
                dismiss(animated: true, completion: nil)
            }
        default: return
        }
    }
}
