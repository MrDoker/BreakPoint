//
//  LoginVC.swift
//  BreakPoint
//
//  Created by DokeR on 12.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: InsetTextField!
    
    @IBOutlet weak var passwordTextField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInBtnWasPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return  }
        AuthService.instance.loginUser(withEmail: email, andPassword: password) { (success, loginError) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("!!!!!!!!!!____loginError_______")
                print(String(describing: loginError?.localizedDescription))
            }
            
            AuthService.instance.registerUser(withEmail: email, andPassword: password, userCreationComplete: { (success, registrationError) in
                if success {
                    AuthService.instance.loginUser(withEmail: email, andPassword: password, loginComplete: { (success, _) in
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    print("!!!!!!!!!!____RegistrationError_______")
                    print(String(describing: registrationError?.localizedDescription))
                }
            })
        }
        
    }
}

extension LoginVC: UITextFieldDelegate {
}
