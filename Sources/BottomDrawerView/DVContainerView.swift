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
	
	init(containing view: UIView) {
		view.frame = .zero
		containingView = view
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
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

