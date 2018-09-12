//
//  DataService.swift
//  BreakPoint
//
//  Created by DokeR on 12.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import Foundation
import Firebase

let dbBase = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _refBase = dbBase
    private var _refUsers = dbBase.child("users")
    private var _refGroups = dbBase.child("groups")
    private var _refFeed = dbBase.child("feed")
    
    var refBase: DatabaseReference {
        return _refBase
    }
    
    var refUsers: DatabaseReference {
        return _refUsers
    }
    
    var refGroups: DatabaseReference {
        return _refGroups
    }
    
    var refFeed: DatabaseReference {
        return _refFeed
    }
    
    func createDBUser(uid: String, userData: [String: Any]) {
        refUsers.child(uid).updateChildValues(userData)
    }
}
