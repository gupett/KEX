//
//  StoreTableViewController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-02.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

class StoreMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // Implementing delegate methods for when a cell gets pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If sign out is pressed a new storeCollectionView will be loaded and when viewdidload is called logedIn is false
        // making the log in screen show
        if indexPath.row == 1 {
            logedIn = false
        }
    }

}
