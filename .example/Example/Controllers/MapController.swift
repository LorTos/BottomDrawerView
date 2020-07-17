//
//  MapController.swift
//  Example
//
//  Created by Lorenzo Toscani De Col on 03/07/2020.
//

import UIKit
import BottomDrawerView

class MapController: UIViewController {
	
	private lazy var tableController = ListTableController(style: .plain)
	
	private lazy var bottomDrawer: DrawerView = {
		let drawer = DrawerView(containing: tableController, inside: self, headerViewHeight: 60)
		drawer.supportedPositions = [DVPosition(0.8), DVPosition(0.4), DVPosition(0.2)]
		drawer.cornerRadius = 24
		drawer.addSubviewToHeaderView(Header(), aligned: .center)
		drawer.tapToExpand = true
		return drawer
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(bottomDrawer)
	}
}

