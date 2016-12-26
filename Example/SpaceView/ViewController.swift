//
//  ViewController.swift
//  SpaceViewExample
//
//  Created by Horoko on 25.12.16.
//  Copyright © 2016 horoko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func showSpace(_ sender: Any) {
        self.showSpace(title: "Title", description: "Description", spaceOptions: nil)
    }
}

