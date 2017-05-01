//
//  MapObjectView.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-05-01.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit

class MapObjectView: UIView {
    
    let image = UIImageView()
    
    
    init(_image : UIImage, _frame: CGRect) {
        self.image.image = _image
        super.init(frame: _frame)
        
        self.image.frame = self.bounds
        self.addSubview(self.image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
