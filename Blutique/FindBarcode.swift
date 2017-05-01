//
//  NetWOrkObject.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-04-13.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation

let productCodes = ["9780130676344": Product(_image: UIImage(named: "Nike_shoe")!, _description: "Very nice shoe made for all type of activities", _sizes: [40, 42, 43], _brand: "Nike", _model: "???"),
                    "1234567891019": Product(_image: #imageLiteral(resourceName: "shoe1"), _description: "Extra dämpining i hälpartiet, Välventilerad, Passar dig med neutralt löparsteg", _sizes: [40, 41, 42, 43], _brand: "Nike", _model: "Air relentless 6 löparsko"),
                    "1234567891026": Product(_image: #imageLiteral(resourceName: "shoe2"), _description: "Passar dig med överpronation, GEL-dämpning i häl och framfot, Med reflexdetaljer som gör att du syns i mörker.", _sizes: [40, 41, 42, 43], _brand: "Asics", _model: "GEL-ZONE 4"),
                    "1234567891033": Product(_image: #imageLiteral(resourceName: "shoe3"), _description: "Lätt och stadig löparsko för löpare med överpronation, GEL-dämpning i häl och framfot, Pålitlig komfort under långa distanser", _sizes: [40, 41, 42, 43], _brand: "Asic", _model: "GT-2000 5 W löparsko"),
                    "1234567891040": Product(_image: #imageLiteral(resourceName: "shoe4"), _description: "Ger foten dämpning i varje steg, Passar för träningspass såväl som för maratonlopp, Bekväm tack vare ovandel i strechnät", _sizes: [40, 41, 42, 43], _brand: "Asics", _model: "ASI GEL-GLORIFY 3"),
                    "1234567891057": Product(_image: #imageLiteral(resourceName: "shoe5"), _description: "Neutral löpartyp, Yttersulan i Continental™ Rubber ger ett optimalt grepp under både våta och torra förhållanden, Gummiyttersula i STRETCHWEB som böjer sig under foten för en energigivande löptur", _sizes: [40, 41, 42, 43], _brand: "Adidas", _model: "Ultra boost löparsko"),
                    "1234567891064": Product(_image: #imageLiteral(resourceName: "shoe6"), _description: "God stabilitet, Mjuk och skön dämpning, Bra grepp", _sizes: [40, 41, 42, 43], _brand: "Nike", _model: "Lunarglide 8 löparsko"),
                    "1234567891071": Product(_image: #imageLiteral(resourceName: "shoe7"), _description: "Passar ett neutralt löpsteg, Boost™ responsiv stötdämpning, TORSION® SYSTEM mellan hälen och framfoten ger stabila löpsteg", _sizes: [40, 41, 42, 43], _brand: "Adidas", _model: "Adizero Adios W löparsko"),
                    "1234567891088": Product(_image: #imageLiteral(resourceName: "shoe8"), _description: "Passar ett neutralt löpsteg, Ventilerande ovandel, Flexibel dämpning", _sizes: [40, 41, 42, 43], _brand: "Nike", _model: "Free RN Flyknit 2017 löparsko"),
                    "1234567891095": Product(_image: #imageLiteral(resourceName: "shoe9"), _description: "Neutral löpartyp, Snabb snörningskonstruktion", _sizes: [40, 41, 42, 43], _brand: "Adidas", _model: "Springblade solyce m löparsko"),
                    "1234567891101": Product(_image: #imageLiteral(resourceName: "shoe10"), _description: "Passar ett neutralt löpsteg \nGod ventilation i ovandelen \nFlexibel dämpning", _sizes: [40, 41, 42, 43], _brand: "Nike", _model: "Free RN löparsko")
      
]

class FindBarcode{
    static func findBarcode(code: String) -> Product?{
        
        if let product = productCodes[code]{
            return product
        }
        return nil
    }
}
