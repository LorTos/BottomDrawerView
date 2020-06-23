//
//  ViewController.swift
//  BottomDrawerViewExample
//
//  Created by Lorenzo Toscani De Col on 23/10/2019.
//  Copyright © 2019 Lorenzo Toscani De Col. All rights reserved.
//

import UIKit
import BottomDrawerView

class ViewController: UIViewController {
	
	private lazy var bottomDrawer: DrawerView = {
		let drawer = DrawerView(containing: UIView(), inside: self, draggableViewHeight: 50)
		drawer.supportedPositions = [.expanded(0.8), .partial(0.8), .collapsed(0.2)]
		return drawer
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(bottomDrawer)
	}
}

