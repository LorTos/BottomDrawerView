//
//  DVContainerView.swift
//  BottomDrawerProject
//
//  Created by Lorenzo Toscani De Col on 15/03/2019.
//  Copyright © 2019 Lorenzo Toscani De Col. All rights reserved.
//

import UIKit

class DVContainerView: UIView {
    
    private(set) var containingView: UIView
    
    init(containing view: UIView, height: CGFloat, topInset: CGFloat = 0) {
        let sizeRect = CGRect(x: 0, y: topInset, width: UIScreen.main.bounds.width, height: height)
        view.frame = sizeRect
        containingView = view
        super.init(frame: sizeRect)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addViewToContainer()
    }
    
    init(containing view: UIView, frame: CGRect) {
        view.frame = frame
        containingView = view
        view.layoutIfNeeded()
        super.init(frame: frame)
        
        backgroundColor = .clear
        addViewToContainer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViewToContainer() {
        containingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containingView.frame = bounds
        addSubview(containingView)
    }
}

