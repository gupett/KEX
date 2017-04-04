//
//  tool_extensions.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-03-30.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import Foundation
import UIKit

// Extention so that all subclasses of collectionview can call method to dismiss keyboard when tapping around on screen 
extension StoreCollectionViewControlerCollectionViewController {
    
    func hideKeyBoardWhenTapAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // functions for moving view when keyboard appears, function is being called when a keyboard notification is observed
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 50
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height - 50
            }
        }
    }
}
