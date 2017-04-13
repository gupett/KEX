//
//  StoreDataObjects.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-13.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

// Dummy data for representing stores
/*
 let beaconPossition = [BeaconPossition(_instanceID: "198235710012036", _xPossition: 0, _yPossition: 0), BeaconPossition(_instanceID: "198235710012037", _xPossition: 1, _yPossition: 0), BeaconPossition(_instanceID: "198235710012044", _xPossition: 0, _yPossition: 1), BeaconPossition(_instanceID: "198235710012046", _xPossition: 1, _yPossition: 1)]
 */

let StoreDataList = [StoreObject(_name: "HM", _logoImage: UIImage(named: "HM")!, _nameSpace: "HM"), StoreObject(_name: "Zara", _logoImage: UIImage(named: "Zara")!, _nameSpace: "Zara"), StoreObject(_name: "Bose", _logoImage: UIImage(named: "Bose")!, _nameSpace: "Bose")]

let nearBeacons = ["HM", "Zara", "Bose"]
