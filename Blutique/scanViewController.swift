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
    
    // List to hold all the products put int to the preOrderList used when displaying the products which are ready to order (when the orderView gets swiped)
    var preOrderList = [Product](){
        didSet{
            // Order view should be added if the list was previously empty and now is is not
            if !preOrderList.isEmpty && oldValue.isEmpty{
                // create order view
                //create tableview
                let tabView = OrderView(frame: CGRect(x: 100, y: 370, width: 50, height: 50))
                tabView.delegate = self
                orderViews.append(tabView)
                self.view.addSubview(tabView)
            }
        }
    }
    
    // List to hold the products that ha been ordered just for help before the server has been implemented
    var orderedProductList = [Product]()
    
    var orderViews = [OrderView]()

    @IBOutlet weak var showMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up barcode scanner
        super.codeDelegate = self
        super.errorDelegate = self
        super.dismissalDelegate = self
        
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

// MARK: - Delegate functions for barcode scanner
// Data handeler
extension ScanViewController: BarcodeScannerCodeDelegate{
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        
        //Hide all the orderViews
        for orderView in orderViews{
            orderView.isHidden = true
        }
        
        // Bool to tell the dispach queue if the product has been found or not, must be class variable in order to be referenced in anaother quque
        productFound = false
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            // If no product was fouind an error can be raised
            if self.productFound == false{
                controller.resetWithError()
                
                // Show the orderViews again sheap solution to delay the showing of the orderViews for the time that the error screen is showen
                DispatchQueue.main.asyncAfter(deadline: delayTime + 4){
                    // Show all the orderViews again
                    for orderView in self.orderViews {
                        orderView.isHidden = false
                    }
                }
            }
        }
        
        // network opperation should be called and no async main queue, it is just for ilustrations when there is no network-op
        DispatchQueue.main.asyncAfter(deadline: delayTime - 5){
            if let product = FindBarcode.findBarcode(code: code) {
                controller.pause = true
                controller.reset(animated: true)
                
                self.productFound = true
                self.scanner = controller
                
                // Creating productView with the found product information
                let productView = ProductView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), product: product)
                productView.delegate = self
                self.view.addSubview(productView)
                
            }
            
        }
    }
    
}

//
extension ScanViewController: ProductViewDelegate{
    
    // start scanning barcodes and dismiss product pop up, ScanDelegate method
    func startScanning(){
        
        // Show all the orderViews again
        for orderView in orderViews {
            orderView.isHidden = false
        }
        
        if let barcodeScanner = scanner{
            barcodeScanner.unPause()
        }
    }
    
    // ScanDelegate method adds the product to the preOrderList together with the previous elements in the preOrderlist
    func preOrderProduct(product: Product){
        self.preOrderList.append(product)
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

// Functions to take care of the movements of the OrderViews
extension ScanViewController: OrderViewDelegate {
    
    // Delegate method for when the view should be big
    func animateToBigView(size: CGSize, orderView: OrderView){
        let r: CGFloat = 15
        
        // Create the rect for the frame which the orderview lies inside, the frame must be bigger than the view containing the orders since the button will be above the and beond the bounds of the productorderView
        let frameRect = CGRect(x: self.view.bounds.midX - (orderView.bigSize.width + r*2)/2, y: self.view.bounds.midY - (orderView.bigSize.height + r*2)/2, width: orderView.bigSize.width + r*2, height: orderView.bigSize.height + r*2)
        
        
        orderView.frame = frameRect
        // Just to show where the frame is for now, should be removed later
        orderView.layer.backgroundColor = UIColor.clear.cgColor
        // Setting the size of the contentview which shows the order infrmation
        orderView.contentView.frame.size = orderView.bigSize
        // Takes the pre-defined size
        orderView.contentView.center = CGPoint(x: frameRect.size.width/2, y: frameRect.size.height/2)
        // Create the button to dismiss to small mode
        orderView.createDismissButton(withRadius: r)
    }
    
    // Delegate method for when the view should be small
    func animateToSmallView(size: CGSize, orderView: OrderView){
        orderView.frame = CGRect(origin: orderView.smallPossition, size: size)
        orderView.contentView.frame = orderView.bounds
    }
    
    // Delegate function to place order
    func placeOrderAnimation(orderView: OrderView){

        // If there is already a view representing the ordered products remove the newley ordered view
        if !orderedProductList.isEmpty{
            orderView.removeFromSuperview()
        }
        
        // Add all products in preOrderList to the orderedProductList
        for product in preOrderList{
            orderedProductList.append(product)
        }
        // Remove all products from preOrderProductList
        preOrderList.removeAll()
        
        // Change the product list for the view for the new state
        orderView.products = orderedProductList
        
        // Animate the movement of the view
        orderView.frame.origin.y = orderView.smallPossition.y - 230
        
        orderView.smallPossition = orderView.frame.origin
    }
    
    func providePreOrderInfo() -> [Product]{
        return preOrderList
    }
    
    func provideOrderedProductInfo() -> [Product]{
        return orderedProductList
    }
    
    // Deletes product from given index in the correct orderlist, used when a row in the tableview is deleted
    func deleteProduc(atRow row: Int, forState: State) {
        if forState == State.ready{
            preOrderList.remove(at: row)
        }else{
            orderedProductList.remove(at: row)
        }
    }
    
    func deleteOrder(forState: State) {
        if forState == State.ready{
            self.preOrderList.removeAll()
            print("the order list is now \(preOrderList)")
        }else{
            self.orderedProductList.removeAll()
            print("the order list is now \(orderedProductList)")
        }
    }
    
    func removeView(orderView: OrderView) {
        for (index, elemet) in orderViews.enumerated(){
            if elemet == orderView{
                orderViews.remove(at: index)
                print("orderView removed from list")
                print("orderViews is now \(orderViews)")
            }
        }
        orderView.removeFromSuperview()
    }
}
