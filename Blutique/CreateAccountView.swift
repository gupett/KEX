//
//  CreateAccountView.swift
//  Blutique
//
//  Created by Gustav Pettersson on 2017-03-28.
//  Copyright © 2017 Gustav Pettersson. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountView: UIView {

    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var e_mail: UITextField!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func createAccount(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: e_mail.text!, password: passWord.text!, completion: {
            (user, error) in
            if (error != nil){
                print("Something went wrong with creation of account")
                print(error)
            }else{
                print("User created")
            }
        })
    }
}
