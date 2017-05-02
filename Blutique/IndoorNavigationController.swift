//
//  IndoorNavigationController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-28.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

class IndoorNavigationController: UIViewController, EILIndoorLocationManagerDelegate {

    
    //Bool that decides if alertNotification is called. Will only happen (once per section)/session
    var launchNotification : Bool = true
    
    //Create the location manager
    let locationManager = EILIndoorLocationManager()
    
    //Create location to fill with location data from cloud
    var location : EILLocation!
    
    //Create outlet for showing the users location and store map
    @IBOutlet weak var IndoorLocationView: EILIndoorLocationView!
    
    @IBOutlet weak var showMenu: UIBarButtonItem!
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.viewIfLoaded != nil && self.location != nil)
        {
            print("view did appear")
            self.locationManager.startPositionUpdates(for: location)
        }
        else
        {
            print("view was loaded")
            self.loadView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Attach application to APP-ID from cloud.
        ESTConfig.setupAppID("bluetique-app-i3k", andAppToken: "f444dcf8f8aec9e8d0855a18286868cb")
        
        //set delegate to self and setup location manager mode
        self.locationManager.delegate = self
        self.locationManager.mode = EILIndoorLocationManagerMode.normal
       
        
        //Fetch location to application
        
        //locations to use are:
        //storebluetique & kista-210
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "storebluetique")
        fetchLocationRequest.sendRequest { (location, error) in
            if let location = location {
                self.location = location
                
                // You can configure the location view to your liking:
                self.IndoorLocationView.showTrace = false
                self.IndoorLocationView.rotateOnPositionUpdate = true
                
                // Configure map drawing settings
                self.IndoorLocationView.showWallLengthLabels = true
                self.IndoorLocationView.showBeacons = true
                self.IndoorLocationView.locationBorderColor = UIColor.black
                self.IndoorLocationView.locationBorderThickness = 4
                self.IndoorLocationView.wallLengthLabelsColor = UIColor.black
                
                
                //create mapobject
                let mapObject = MapObjectView(_image: #imageLiteral(resourceName: "shoe_icon"), _frame: CGRect(x: 0, y: 0, width: 70, height: 70))
                let orientedPoint = EILOrientedPoint(x: 6.0, y: 9.0)
 
              
 
                //Draw the map
                self.IndoorLocationView.drawLocation(location)
                
                //draw mapobject in the map
                self.IndoorLocationView.drawObject(inForeground: mapObject, withPosition: orientedPoint, identifier: "shoe-image")
                
                self.locationManager.startPositionUpdates(for: self.location)
            } else {
                print("can't fetch location: \(String(describing: error))")
            }
        }
        
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
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didFailToUpdatePositionWithError error: Error) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didUpdatePosition position: EILOrientedPoint, with positionAccuracy: EILPositionAccuracy, in location: EILLocation) {
        
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f", position.x, position.y, position.orientation))
        
        //update position
        self.IndoorLocationView.updatePosition(position)
        
        //notification if in Shoe section
        let shoe_section = EILPoint(x: 8.5, y: 4.7)
        
        if(position.distance(to: shoe_section) < 1)
        {
            //Will only launch first time in new section per session of store visit
            if(launchNotification)
            {
                let alertController = UIAlertController(title: "Bluetique", message: "Welcome to The Shoe Section", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                launchNotification = false
            }
        }
        
        
    }




}
