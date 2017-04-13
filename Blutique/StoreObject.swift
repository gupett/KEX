//
//  StoreObject.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-13.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

// Object to store relevante information regarding a store
class StoreObject{
    
    let name: String
    let logoImage: UIImage
    let nameSpace: String
    
    init(_name: String, _logoImage: UIImage, _nameSpace: String){
        self.name = _name
        self.logoImage = _logoImage
        self.nameSpace = _nameSpace
    }
    
}
