//
//  NetWOrkObject.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-13.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

let productCodes = ["9780130676344": Product(_image: UIImage(named: "Nike_shoe")!, _description: "Very nice shoe made for all type of activities", _sizes: [40, 42, 43], _brand: "Nike")]

class FindBarcode{
    static func findBarcode(code: String) -> Product?{
        
        if let product = productCodes[code]{
            return product
        }
        return nil
    }
}
