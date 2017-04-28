//
//  OrderView.swift
//  animateUp_test
//
//  Created by Gustav Pettersson on 2017-04-21.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

enum State{
    case showOrder
    case ready
    case ordered
    
    var style: Style{
        let style: Style
        
        switch self {
        case .showOrder:
            style = Style(
                _heightRatio: 0.5,
                _widthRatio: 0.5,
                _color: UIColor.white,
                _borderColor: UIColor.black,
                _borderWidth: 3,
                _tableHidden: false)
        case .ready:
            style = Style(
                _heightRatio: 1,
                _widthRatio: 1,
                _color: UIColor.blue,
                _borderColor: UIColor.blue,
                _borderWidth: 0,
                _tableHidden: true)
        case .ordered:
            style = Style(
                _heightRatio: 1,
                _widthRatio: 1,
                _color: UIColor.red,
                _borderColor: UIColor.red,
                _borderWidth: 0,
                _tableHidden: true)
        }
        
        return style
    }
}

// Struct to tell the styling for the view depending on the state the view is currently in
struct Style {
    let heightRatio: CGFloat
    let widthRatio: CGFloat
    let color: UIColor
    let borderColor: UIColor
    let borderWidth: CGFloat
    let tableHidden: Bool
    
    init(_heightRatio: CGFloat, _widthRatio: CGFloat, _color: UIColor, _borderColor: UIColor, _borderWidth: CGFloat, _tableHidden: Bool) {
        self.heightRatio = _heightRatio
        self.widthRatio = _widthRatio
        self.color = _color
        self.borderColor = _borderColor
        self.borderWidth = _borderWidth
        self.tableHidden = _tableHidden
    }
}


protocol OrderViewDelegate {
    func animateToBigView(size: CGSize, orderView: OrderView)
    
    func animateToSmallView(size: CGSize, orderView: OrderView)
    
    func placeOrderAnimation(orderView: OrderView)
    
    func providePreOrderInfo() -> [Product]
    
    func provideOrderedProductInfo() -> [Product]
    
    func deleteProduc(atRow row: Int, forState: State)
    
    func deleteOrder(forState: State)
    
    func removeView(orderView: OrderView)
}

class OrderView: UIView, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var table: UITableView!

    @IBOutlet var contentView: UIView!
    
    // The size of the view when it is not in showProduct state
    var smallSize = CGSize(width: 30, height: 30)
    // Variable to tell the origin of the view for when it is in small mode, decided by the controlling view
    var smallPossition: CGPoint
    
    // The size of the view for when the view is in showProduct state
    var bigSize = CGSize(width: 270, height: 370)
    
    // Class incharge of moving and animating the view
    var delegate: OrderViewDelegate!
    
    // Variable to tell if the view is ordered or ready to order to know what state to go back to after showOrder state
    private var orderState = State.ready
    
    // Variable to hold the list of products
    var products: [Product] = [Product]()
    
    // Depending on how the state of the view changes the apparence of the view will change and is mostly controlled by the didSet block
    private var state: State{
        didSet{
            // If old value is same as new, do nothing
            if state == oldValue{
                return
            }
            switch self.state {
            case .showOrder:
                // To make sure the products list is up to date with the added products
                loadProductList()

                // Function to animate the view to big mode in the view containing the orderView
                delegate.animateToBigView(size: self.bigSize, orderView: self)
                //Should pause the camera
                
                // Call a data source delegate method to populate the view with data
            case .ready:
                // If the product list becomes empty the view should remove itself
                if products.isEmpty{
                    self.delegate.removeView(orderView: self)
                }
            case .ordered:
                
                // only when the orderstate is .ready can a order be sent else it has already been ordered
                if orderState == .ready{
                    delegate.placeOrderAnimation(orderView: self)
                    self.orderState = .ordered
                }
                
                // If the product list becomes empty the view should remove itself
                if products.isEmpty{
                    self.delegate.removeView(orderView: self)
                }
            }
            //Styles the view acording to the current state of the view
            styleViewForCurrentState()
        }
    }

    // Current initializer, probably should be changed to one that sets the size for small and big mode and the origin of the view
    override init(frame: CGRect){
        // Set the default possition for the view for when it is small
        self.smallPossition = frame.origin
        // default size of the view in small mode
        self.smallSize = frame.size
        // the starting state of the view
        self.state = .ready

        super.init(frame: frame)
        
        // Initialize the nib file containing the tableview
        initTableView()
        // Make sure the view hass the correct style for the state it is in
        styleViewForCurrentState()
        // Add the gestures related to the view (tapToBigMode, swipeToOrder)
        setUpGestureRecognizersForView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helperfunctions for the initialization of the view
    
    private func initTableView(){
        
        Bundle.main.loadNibNamed("tableView", owner: self, options: nil)

        // setting constraints
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
       // Styling the tableView
        self.layer.cornerRadius = 6
        self.table.layer.borderColor = UIColor.black.cgColor
        self.table.layer.borderWidth = 3
        self.table.layer.cornerRadius = 6
        self.table.backgroundColor = UIColor.white

        addSubview(contentView)

    }
    
    private func setUpGestureRecognizersForView(){
        // Action to be made when the view is tapped, go to big view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(sender:)))
        tapRecognizer.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(tapRecognizer)
        
        // Action to be made when the view is swiped up, place order
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        swipeRecognizer.direction = .up
        contentView.addGestureRecognizer(swipeRecognizer)
        
        // ADD a long press gesture to delete a order when in small mode
        let longTapRec = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(sender:)))
        longTapRec.minimumPressDuration = 3
        contentView.addGestureRecognizer(longTapRec)
    }
    
    
    
    // MARK: - Gesture functions
    
    // Function to performe when view tapped, shoud bring up big mode for the view to show the order
    func tapped(sender: UIGestureRecognizer){
        print("I was tapped")
        if self.state != .showOrder{
            self.state = State.showOrder
        }
    }
    
    // Function to performe when the view was swiped
    func swiped(sender: UIGestureRecognizer){
        print("I was swiped")
        print(state)
        if self.state == .ready{
            self.state = State.ordered
        }
    }
    
    // When a long press has been done the view should be removed and the orderList should be emptied
    func longPress(sender: UILongPressGestureRecognizer){
        print("Long press")
        delegate.deleteOrder(forState: self.orderState)
        self.delegate.removeView(orderView: self)
    }
    
    // MARK: - Styling functions
    
    private func styleViewForCurrentState(){
        //self.contentView.frame.size.height = self.frame.height * state.style.heightRatio
        //self.contentView.frame.size.width = self.frame.width * state.style.widthRatio
        self.contentView.backgroundColor = state.style.color
        self.contentView.layer.borderColor = state.style.borderColor.cgColor
        self.contentView.layer.borderWidth = state.style.borderWidth
        self.table.isHidden = state.style.tableHidden
        
        // Set the corner radious and gestures acording to state
        if state != .showOrder{
            self.contentView.layer.cornerRadius = self.smallSize.height/2
            // Enable all gesture recognizers when in smallMode
            // The gesture list could be empty so it must be checked
            if let gestureList = self.contentView.gestureRecognizers{
                for gesture in gestureList{
                    gesture.isEnabled = true
                }
            }
            
        }else{
            self.contentView.layer.cornerRadius = 6
            // Dissable all gesture recognizers when in bigMode
            // the gesture list can never be empty since the only way to get to bigMode is throug a tap gesture
            for gesture in self.contentView.gestureRecognizers!{
                gesture.isEnabled = false
            }
        }
        
    }
    
    // Function creating a button that will go from .showOrder to eighter .ready or .ordered depending on previous state
    func createDismissButton(withRadius r: CGFloat){
        
        // Create button
        let buttonRect = CGRect(x: self.contentView.frame.minX - r, y: self.contentView.frame.minY - r, width: r*2, height: r*2)
        let button = UIButton(frame: buttonRect)
        
        //Styling button
        button.layer.cornerRadius = r
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = UIColor.black.cgColor
        self.addSubview(button)
        
        // Add action to button
        button.addTarget(self, action: #selector(dismissShowOrder(sender:)), for: .touchUpInside)
    }
    
    //action for when button was pressed
    func dismissShowOrder(sender: UIButton!){
        // state should take the state of before the showorder state
        self.state = self.orderState
        
        delegate.animateToSmallView(size: self.smallSize, orderView: self)
        print("button pressed")
        // remove the dismiss button
        sender.removeFromSuperview()
    }
    
    
    // MARK: - Table view data source
    
    // Tells the number of rows in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    // Data source function configuring the cells in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        // configuring the cell
        cell.productImage.image = products[indexPath.row].image
        cell.label.text = "\(products[indexPath.row].brand) of size \(products[indexPath.row].sizes[0])"
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    // Function to tell if a sertain row can be edited
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // function to enable swiping to left to show delete button, canEditRowAt also must give true
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            // Remove the data at the selected row and refresh the tableview
            delegate.deleteProduc(atRow: indexPath.row, forState: self.orderState)
            loadProductList()
            table.reloadData()
        }
    }
    
    // MARK: - Table view delegate functions
    
    // Delegate function vill be called when a row in the tableView is pressed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Makes the cell only highlight during tap
        print("TAP...")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Delegate function tells the height of cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Use to change the hight of cell when pressed?
        return 44
    }
    
    // Loads the correct product list for the given state
    private func loadProductList(){
        if orderState == .ready{
            self.products = delegate.providePreOrderInfo()
        }else{
            self.products = delegate.provideOrderedProductInfo()
        }
    }
    
}
