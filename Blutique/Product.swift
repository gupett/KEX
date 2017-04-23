//
//  Product.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-18.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

class Product{
    let image: UIImage
    let description: String
    let sizes: [Int]
    
    init(_image: UIImage, _description: String, _sizes: [Int]) {
        self.image = _image
        self.description = _description
        self.sizes = _sizes
    }
}
