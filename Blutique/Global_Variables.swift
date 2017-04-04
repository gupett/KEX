//
//  Global_Variables.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-03-30.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

var storeNavController: StoreCollectionViewControlerCollectionViewController? = nil{
    didSet{
        print("storeNavController just got a new value: \(storeNavController)")
    }
}

var logedIn = true {
    didSet{
    
    }
}

var inStoreNavControler: UIViewController? = nil {
    didSet{
        print("inStoreNavControler just got a new value: \(inStoreNavControler)")
    }
}


