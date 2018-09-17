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
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupLEy groupKey: String?, sendComplete: @escaping (_ success: Bool) -> () ) {
        
        if groupKey != nil {
            //send to group
        } else {
            refFeed.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messagesArray: [Message]) -> () ) {
        var messageArray = [Message]()
        
        refFeed.observeSingleEvent(of: .value, with: { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                
                let newMessage = Message(content: content, senderId: senderId)
                messageArray.append(newMessage)
            }
            handler(messageArray)
        })
    }
    
}
