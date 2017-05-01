//
//  Product.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-18.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

struct Product{
    let image: UIImage
    let description: String
    var sizes: [Int]
    let brand: String
    let model: String
    
    init(_image: UIImage, _description: String, _sizes: [Int], _brand: String, _model: String) {
        self.image = _image
        self.description = _description
        self.sizes = _sizes
        self.brand = _brand
        self.model = _model
    }
}
