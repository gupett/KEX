//
//  IndoorNavigationController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-28.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

class IndoorNavigationController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // To set up the sidebarMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }



}
