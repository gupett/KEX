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
    
    // Variable to tell scanning if product was found
    var productFound: Bool!
    
    var scanner: BarcodeScannerController?
    
    var productView: ProductView?
    

    @IBOutlet weak var showMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Test function
        // setting up barcode scanner
        super.codeDelegate = self
        super.errorDelegate = self
        super.dismissalDelegate = self
        
        // Set up action for menuButton, all functionality is provider in SWrecealViewController
       
            /*showMenu.target = self.revealViewController()
            showMenu.action = #selector(SWRevealViewController.revealToggle(_:))*/
        
        if self.revealViewController() != nil{
            
            //Changes the with of the side menu
            self.revealViewController().rearViewRevealWidth = self.view.bounds.width * 0.5
            
            showMenu.target = self.revealViewController()
            showMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            
            // Adding touch gesture for bringing the menu in/ out
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
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
        
        productFound = false
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if self.productFound == false{
                controller.resetWithError()
            }
        }
        
        // network opperation should be called and no async main queue, it is just for ilustrations when there is no network-op
        DispatchQueue.main.asyncAfter(deadline: delayTime - 1){
            if let product = FindBarcode.findBarcode(code: code) {
                controller.pause = true
                controller.reset(animated: true)
                
                self.productFound = true
                self.scanner = controller
               
                self.showProductView(product: product)
            }
            
        }
    }
    
    // start scanning barcodes and dismiss product pop up
    func startScanning(){
        if let barcodeScanner = scanner{
            barcodeScanner.unPause()
        }
    }
    
    // Instantiate view showing product Information
    func showProductView(product: Product){
        if let viewPr = Bundle.main.loadNibNamed("ProductView", owner: self, options: nil)?.first as? ProductView{
            productView = viewPr
            productView?.frame.size.height = self.view.frame.height * 0.80 - (self.navigationController?.navigationBar.frame.height)!
            productView?.frame.size.width = self.view.frame.width * 0.85
            
            productView?.productImage.image = product.image
            productView?.productInfo.text = product.description
            productView?.productInfo.isEditable = false
            productView?.layer.cornerRadius = 5
            productView?.center = self.view.center
            productView?.center.y = self.view.center.y + (self.navigationController?.navigationBar.frame.height)! / 2
            self.view.addSubview((productView)!)
            
            // Creating a dismiss button
            let radius: CGFloat = 15
            let xPos = (productView?.frame.minX)! - radius
            let yPos = (productView?.frame.minY)! - radius
            let buttonRect = CGRect(x: xPos, y: yPos, width: radius*2, height: radius*2)
            let exitButton = UIButton(frame: buttonRect)
            exitButton.layer.cornerRadius = radius
            exitButton.layer.backgroundColor = UIColor.black.cgColor
            exitButton.setTitle("X", for: .normal)
            exitButton.setTitleColor(UIColor.white, for: .normal)
            // Set an image to the button
            
            exitButton.addTarget(self, action: #selector(self.dismissProductView(sender:)), for: .touchUpInside)
            self.view.addSubview(exitButton)
        }
    }
    
    func dismissProductView(sender: UIButton!){
        if let productview = self.productView{
            productview.removeFromSuperview()
            self.productView = nil
            sender.removeFromSuperview()
        }
        startScanning()
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
