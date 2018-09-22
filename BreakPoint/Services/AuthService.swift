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
            
            let userData = ["provider": user.providerID, "email": user.email, "avatarURL": "https://firebasestorage.googleapis.com/v0/b/breakpoint-6722a.appspot.com/o/usersAvatars%2FdefaultProfileImage%403x.png?alt=media&token=1efc91a8-bc57-4a90-8a2a-7db5575268a7"]
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
