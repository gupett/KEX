//
//  ProductView.swift
//  animateUp_test
//
//  Created by Gustav Pettersson on 2017-04-21.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

protocol ProductViewDelegate {
    func startScanning()
    func preOrderProduct(product: Product)
}

class ProductView: UIView {

    /*@IBOutlet var contentView: UIView!
   
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productText: UITextView!*/
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productText: UITextView!

    var delegate: ProductViewDelegate!
    
    var product: Product
    
    init(frame: CGRect, product: Product){
        self.product = product
        super.init(frame: frame)
        nibInit()
        
        //Dismiss button
        createDismiddButton()
        
        setUpViewForProduct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function to initiate contentview from nibfile
    private func nibInit(){
        
        // Load nib from bundle
        Bundle.main.loadNibNamed("ProductView", owner: self, options: nil)
        
        // Setting constraints for the view
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.productText.isEditable = false
        
        // Place the view in the middle of the superView
        contentView.frame.size.height = self.frame.height * 0.80 - 44
        contentView.frame.size.width = self.frame.width * 0.85
        let centerPoint = CGPoint(x: self.center.x, y: self.center.y + 22)
        contentView.center = centerPoint
        
        // Styling the contentView
        contentView.layer.cornerRadius = 6
        
        // Add the content view to self
        addSubview(contentView)
    }
    
    private func createDismiddButton(){
        // Creating button
        let r: CGFloat = 20
        let buttonRect = CGRect(x: self.contentView.frame.minX - r, y: self.contentView.frame.minY - r, width: r*2, height: r*2)
        let button = UIButton(frame: buttonRect)
        
        // Styling button
        button.layer.cornerRadius = r
        button.backgroundColor = UIColor.gray
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        
        // Action for button
        button.addTarget(self, action: #selector(self.removeView(sender:)), for: .touchUpInside)
        
        // Adding button to screen
        self.addSubview(button)
        
    }
    
    // Action to be performed when button pressed
    func removeView(sender: UIButton!){
        self.removeFromSuperview()
        delegate.startScanning()
    }
    
    func setUpViewForProduct(){
        self.productImage.image = product.image
        self.productText.text = product.description
        createButtonForSizes(sizes: product.sizes)
    }
    
    func createButtonForSizes(sizes: [Int]){
        let startX = self.productImage.frame.minX
        let endX = self.productText.frame.maxX // gives strange resut seames to be outside of the expected point
        let startY = self.productText.frame.maxY
        let padding: CGFloat = 10
        // Calculate distance between start and end
        let dist = (endX) - startX - 10
        let widthButton: CGFloat = dist / CGFloat(sizes.count)
        
        self.backgroundColor = UIColor.black
        
        // Not working as expected the end of the image endX gives strange results
        for (index, size) in sizes.enumerated(){
            
            // Placing the buttons on a line
            let buttonRect = CGRect(x: startX + widthButton * CGFloat(index), y: startY, width: widthButton - padding, height: 30)
            let button = UIButton(frame: buttonRect)
            
            // Styling button
            button.setTitle("\(size)", for: .normal)
            button.backgroundColor = UIColor.black
            button.layer.cornerRadius = 5
            
            // Adding action to button
            button.addTarget(self, action: #selector(self.addProductToOrder(sender:)), for: .touchUpInside)
            
            contentView.addSubview(button)
        }
        
    }
    
    func addProductToOrder(sender: UIButton!){
        print("Product should be added with size: \(sender.titleLabel?.text)")
        removeView(sender: sender)
        delegate.preOrderProduct(product: self.product)
    }
}
