//
//  scanViewController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-03-29.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import AVFoundation

class ScanViewController: RSCodeReaderViewController {

    @IBOutlet weak var showMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
            }
        }
        
        
        // Set up action for menuButton, all functionality is provider in SWrecealViewController
       
            showMenu.target = self.revealViewController()
            showMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
