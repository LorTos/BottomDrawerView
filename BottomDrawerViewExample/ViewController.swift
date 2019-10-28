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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func presentDrawer(_ sender: Any) {
        let drawer = BottomDrawer(containingView: UIView(), height: 400)
//        drawer.modalPresentationStyle = .overFullScreen
//        drawer.modalTransitionStyle = .crossDissolve
        present(drawer, animated: true, completion: nil)
    }
}

