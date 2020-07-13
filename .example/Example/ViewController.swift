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
		let drawer = DrawerView(containing: UIView(), inside: self, headerViewHeight: 60)
		drawer.supportedPositions = [DVPosition(0.8), DVPosition(0.2)]
		drawer.cornerRadius = 24
		drawer.addSubviewToInteractiveView(headerStack, aligned: .center)
		drawer.tapToExpand = true
		return drawer
	}()
	
	private lazy var headerStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [lineView, titleLabel])
		stack.axis = .vertical
		stack.distribution = .equalCentering
		stack.alignment = .center
		return stack
	}()
	
	private lazy var lineView: UIView = {
		let line = UIView(frame: .zero)
		line.widthAnchor.constraint(equalToConstant: 100).isActive = true
		line.heightAnchor.constraint(equalToConstant: 4).isActive = true
		line.backgroundColor = UIColor.black.withAlphaComponent(0.3)
		line.layer.cornerRadius = 2
		line.layer.masksToBounds = true
		return line
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

