//
//  ViewController.swift
//  Example
//
//  Created by Lorenzo Toscani De Col on 03/07/2020.
//

import UIKit
import BottomDrawerView

class ViewController: UIViewController {
	
	private lazy var bottomDrawer: DrawerView = {
		let drawer = DrawerView(containing: UIView(), inside: self, draggableViewHeight: 80)
		drawer.supportedPositions = [DVPosition(0.8), DVPosition(0.2)]
		drawer.cornerRadius = 24
		drawer.addSubviewToInteractiveView(titleLabel, aligned: .center)
		return drawer
	}()
	private lazy var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "Title"
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(bottomDrawer)
	}
	
}

