//
//  NetWOrkObject.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-13.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

let productCodes = ["9780130676344", "77988908"]

class FindBarcode{
    static func findBarcode(code: String) -> Bool{
        for product in productCodes{
            if product == code{
                return true
            }
        }
        return false
    }
}
