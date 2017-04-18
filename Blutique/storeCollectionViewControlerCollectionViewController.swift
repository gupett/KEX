//
//  storeCollectionViewControlerCollectionViewController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-03-29.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class StoreCollectionViewControlerCollectionViewController: UICollectionViewController, LogInDelegate {
    
    //@IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var logInView: LogInView!
    @IBOutlet var createAccountView: CreateAccountView!
    @IBOutlet var overLay: UIView!
    @IBOutlet weak var showMenu: UIBarButtonItem!

    var refresher: UIRefreshControl!
    
    
    var createAccountVie = false
    
    // placeholder for lrft barbutton item
    var leftBarButtonItem: UIBarButtonItem?
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        //Best func yet
        print("hope hope hope")
        
        super.viewWillAppear(animated)
        
        if logedIn == false{
            leftBarButtonItem = self.navigationItem.leftBarButtonItem
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //new to master branch 
        print("thhis is master branch")
        
        //Set up the refresh-controller
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Refreshing stores")
        refresher.addTarget(self, action: #selector(self.refreshStores), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        // set ref to global variable
        storeNavController = self
        
        // Set up the view
        logInView.layer.cornerRadius = 6
        
        // Se up delegates
        logInView.delegate = self
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // check to see if user is loged in
        if logedIn == false{
            view.addSubview(overLay)
            // if not loged in display the log in view and let it handle authentications
            animateIn()
        }
        
        // Seting up side menu
        if self.revealViewController() != nil{
            // Set up action for menuButton, all functionality is provider in SWrecealViewController
            showMenu.target = self.revealViewController()
            showMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            // Set up the width of sidemenu
            self.revealViewController().rearViewRevealWidth = self.view.bounds.width * 0.5
        }
        

        // Dismiss the keyboard if taped outside.
        self.hideKeyBoardWhenTapAround()
        
        //Moving views when keyboard appears, when one of the observations is observed the coresponding selector function is called
        NotificationCenter.default.addObserver(self, selector: #selector(StoreCollectionViewControlerCollectionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StoreCollectionViewControlerCollectionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return nearBeacons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? StoreCollectionViewCell{
            
            // Find near beacons from store list and set image to that store
            let id = nearBeacons[indexPath.row]
            for store in StoreDataList {
                if id == store.nameSpace{
                    print("setting up image")
                    cell.logoImage.image = store.logoImage
                    //logoImage.image = store.logoImage
                    
                    
                }
            }
            
            
        
            // Configure the cell
            cell.layer.cornerRadius = 110
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 2
            
            return cell
            
        }
       return cell1
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        
        print("cell \(indexPath) was selected")
        
        //if inStoreNavControler == nil {
            let inStoreController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InStoreController")
            inStoreNavControler = inStoreController
            self.present(inStoreController, animated: true, completion: nil)
        //}else{
          //  self.present(inStoreNavControler!, animated: false, completion: nil)
        //}
        
        
        return true
    }
    
    // function to be called when refreshing
    func refreshStores(){
        print("loading new stores")
        // loadig new data in to the collectionview
        self.collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    // MARK: handle logIn- and createAccount- view
    
    // To show the log in view
    func animateIn(){
        self.view.addSubview(logInView)
        self.logInView.center = self.view.center
        
        self.logInView.transform.scaledBy(x: 1.3, y: 1.3)
        self.logInView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.logInView.alpha = 1
            
        })
    }
    
    // Dismiss the log in view
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.logInView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.logInView.alpha = 0
                
        }) { (sucsess:Bool) in
                self.overLay.removeFromSuperview()
                self.logInView.removeFromSuperview()
            
                // If the barbutton item does not show it is better for the app to crash
                self.navigationItem.leftBarButtonItem = self.leftBarButtonItem!
            
        }
    }
        
        
    func logedInWithSuccess() {
            logedIn = true
            animateOut()
    }
    
        // Change log in views
        
    @IBAction func goToCreateAccount(_ sender: Any) {
        self.view.addSubview(self.createAccountView)
        self.createAccountView.layer.cornerRadius = 6
        self.createAccountView.center = self.view.center
        UIView.transition(from: logInView, to: createAccountView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], completion:{
            (sucsess:Bool) in
        })
    }
    
    @IBAction func goToLogIn(_ sender: Any) {
        UIView.transition(from: createAccountView, to: logInView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
   
}
