//
//  IndoorNavigationController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-28.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

class IndoorNavigationController: UIViewController {

    
    @IBOutlet weak var showMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // To set up the sidebarMenu
        // Set up action for menuButton, all functionality is provider in SWrecealViewController
        if self.revealViewController() != nil{
            
            //Changes the with of the side menu
            self.revealViewController().rearViewRevealWidth = self.view.bounds.width * 0.5
            
            showMenu.target = self.revealViewController()
            showMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            
            // Adding touch gesture for bringing the menu in/ out
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }



}
