//
//  scanViewController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-03-29.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit
import BarcodeScanner
import AVFoundation

class ScanViewController: BarcodeScannerController  {

    @IBOutlet weak var showMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Test function
        // setting up barcode scanner
        super.codeDelegate = self
        super.errorDelegate = self
        super.dismissalDelegate = self
        
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

// MARK: - Delegate functions for barcode scanner
// Data handeler
extension ScanViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
}

// Error handeler
extension ScanViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

// Handeler when the barcode scanner is dismissed
extension ScanViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
