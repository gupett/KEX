//
//  LogInView.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-02-11.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit
import Firebase

protocol LogInDelegate {
    func logedInWithSuccess()
}

class LogInView: UIView {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    var testVariabel : String!
    
   
    var delegate: LogInDelegate?
    
    @IBAction func logIn(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: userName.text!, password: passWord.text!, completion: {
            (user, error) in
            if error != nil {
                print("error when signing in")
            }else{
                self.resignFirstResponder() // to dismiss the keyboard?
                self.delegate?.logedInWithSuccess()
            }
        })
        
        
    }
    
    @IBAction func goToLogIn(_ sender: Any) {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
