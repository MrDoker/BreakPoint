//
//  AuthService.swift
//  BreakPoint
//
//  Created by DokeR on 12.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ success: Bool, _ error: Error?) -> () ) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            guard let user = authDataResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as [String : Any])
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ success: Bool, _ error: Error?) -> () ) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            guard (authDataResult?.user) != nil else {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
