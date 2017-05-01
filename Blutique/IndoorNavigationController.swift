//
//  IndoorNavigationController.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-28.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

class IndoorNavigationController: UIViewController, EILIndoorLocationManagerDelegate {

    @IBOutlet weak var xValue: UILabel!
    @IBOutlet weak var yValue: UILabel!
    @IBOutlet weak var orientationValue: UILabel!
    
    //Create the location manager
    let locationManager = EILIndoorLocationManager()
    
    //Create location to fill with location data from cloud
    var location : EILLocation!
    
    //Create outlet for showing the users location and store map
    @IBOutlet weak var IndoorLocationView: EILIndoorLocationView!
    
    @IBOutlet weak var showMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Attach application to APP-ID from cloud.
        ESTConfig.setupAppID("bluetique-app-i3k", andAppToken: "f444dcf8f8aec9e8d0855a18286868cb")
        
        //set delegate to self and setup location manager mode
        self.locationManager.delegate = self
        self.locationManager.mode = EILIndoorLocationManagerMode.normal
       
        
        //Fetch location to application
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "kista-210")
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
                self.IndoorLocationView.locationBorderThickness = 6
                self.IndoorLocationView.traceColor = UIColor.blue
                self.IndoorLocationView.traceThickness = 2
                self.IndoorLocationView.wallLengthLabelsColor = UIColor.black
                
                /*
                //create mapobject
                let mapObject = MapObjectView(_image: #imageLiteral(resourceName: "shoe_icon"), _frame: CGRect(x: 0, y: 0, width: 30, height: 30 ))
                let orientedPoint = EILOrientedPoint(x: 10.0, y: 7.0)
                //draw mapobject in the middle of the map
                
                self.IndoorLocationView.drawObject(inForeground: mapObject, withPosition: orientedPoint, identifier: "shoe-image")
                 */
               
                self.IndoorLocationView.drawLocation(location)
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
        self.xValue.text = position.x.description
        self.yValue.text = position.y.description
        self.orientationValue.text = position.orientation.description
        
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f", position.x, position.y, position.orientation))
        
        self.IndoorLocationView.updatePosition(position)
    }




}
