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
let storage = Storage.storage().reference()

class DataService {
    static let instance = DataService()

    private(set) public var refBase = dbBase
    private(set) public var refUsers = dbBase.child("users")
    private(set) public var refGroups = dbBase.child("groups")
    private(set) public var refFeed = dbBase.child("feed")
    private(set) public var storageRef = storage.child("usersAvatars")
    
    func createDBUser(uid: String, userData: [String: Any]) {
        refUsers.child(uid).updateChildValues(userData)
    }
    
    func uploadUserAvatar(imageData: Data, handler: @escaping (_ imageURL: URL?) -> ()) {
        let userID = Auth.auth().currentUser!.uid
        let userAvatarRef = storageRef.child("\(userID).jpg")
        
        // Upload the file to the path
        userAvatarRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                handler(nil)
                print(error.debugDescription)
            }
            
            userAvatarRef.downloadURL { (url, error) in
                guard let downloadedURL = url else { return }
                self.refUsers.child(userID).updateChildValues(["avatarURL": downloadedURL.absoluteString], withCompletionBlock: { (error, userDatabaseReference) in
                    ///handle errors
                    handler(downloadedURL)
                })
            }
        }
    }
    
    func getUserName(forUID uid: String, handler: @escaping (_ username: String) ->() ) {
        refUsers.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func getUserAvatar(forUID uid: String, handler: @escaping (_ avatarURL: String) ->() ) {
        refUsers.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "avatarURL").value as! String)
                }
            }
        }
    }
    
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ success: Bool) -> () ) {
        
        if groupKey != nil {
            refGroups.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
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
    
    //New way
    func getAllFeedMessagesNewWay(handler: @escaping (_ messagesArray: [NewMessage]) -> () ) {
        var messageArray = [NewMessage]()
        
        refFeed.observeSingleEvent(of: .value, with: { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                
                self.getUserName(forUID: senderId) { (email) in
                    self.getUserAvatar(forUID: senderId) { (returnedImageURL) in
                        let newMessage = NewMessage(content: content, senderEmail: email, senderImageURL: returnedImageURL, key: message.key, senderID: senderId)
                        messageArray.append(newMessage)
                        if messageArray.count == feedMessageSnapshot.count {
                            handler(messageArray)
                        }
                    }
                }
            }
        })
    }
    
    func observeFeedForNewMessages(handler: @escaping (_ newMessage: NewMessage) -> ()) {
        refFeed.observe(.value) { (feedDataSnapshot) in
            guard let feedDataSnapshot = feedDataSnapshot.children.allObjects as? [DataSnapshot] else {return}
            let newMessage = feedDataSnapshot.last
            
            let content = newMessage?.childSnapshot(forPath: "content").value as! String
            let senderId = newMessage?.childSnapshot(forPath: "senderId").value as! String
            let key = newMessage?.key
            
            self.getUserName(forUID: senderId, handler: { (email) in
                self.getUserAvatar(forUID: senderId, handler: { (returnedImageURL) in
                    let newMessage = NewMessage(content: content, senderEmail: email, senderImageURL: returnedImageURL, key: key ?? "errorKey", senderID: senderId)
                    handler(newMessage)
                })
            })
        }
    }
    
    
    //new way
    func getAllMessagesFor(desiredGroup group: Group, handler: @escaping (_ messagesArray: [NewMessage]) -> ()) {
        var messagesArray = [NewMessage]()
        
        refGroups.child(group.key).child("messages").observe(.value) { (groupMessagesDataSnapshot) in
            guard let groupMessagesDataSnapshot = groupMessagesDataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessagesDataSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let key = groupMessage.key
                
                self.getUserName(forUID: senderId, handler: { (email) in
                    self.getUserAvatar(forUID: senderId, handler: { (returnedImageURL) in
                        let newMessage = NewMessage(content: content, senderEmail: email, senderImageURL: returnedImageURL, key: key, senderID: senderId)
                        messagesArray.append(newMessage)
                        if messagesArray.count == groupMessagesDataSnapshot.count {
                            handler(messagesArray)
                        }
                    })
                })
            }
        }
    }
    
    func getAllMessagesForUser(handler: @escaping (_ feedMessages: [NewMessage], _ groupsMessages: [String: [NewMessage]]) -> ()) {
        var feedMessages = [NewMessage]()
        var groupWithMessagesDict = [String: [NewMessage]]()
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        refFeed.observeSingleEvent(of: .value) { (feedDataSnapshot) in
            guard let feedMessageSnapshot = feedDataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for message in feedMessageSnapshot {
                let senderID = message.childSnapshot(forPath: "senderId").value as! String
                if userID == senderID {
                    let content = message.childSnapshot(forPath: "content").value as! String
                    let newMessage = NewMessage(content: content, senderEmail: "", senderImageURL: "", key: "", senderID: "")
                    feedMessages.append(newMessage)
                }
            }

        }
        
        refGroups.observeSingleEvent(of: .value) { (groupDataSnapshot) in
            guard let groupDataSnapshot = groupDataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupDataSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains(userID) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    
                    var groupMessages = [NewMessage]()
                    let messagesDataSnapshot = group.childSnapshot(forPath: "messages").children.allObjects as! [DataSnapshot]
                    for groupMessage in messagesDataSnapshot {
                        let content = groupMessage.childSnapshot(forPath: "content").value as! String
                        let senderID = groupMessage.childSnapshot(forPath: "senderId").value as! String
                        
                        if senderID == userID {
                            let newMessage = NewMessage(content: content, senderEmail: "", senderImageURL: "", key: "", senderID: "")
                            groupMessages.append(newMessage)
                            //print(groupMessages.count)
                        }
                    }
                    groupWithMessagesDict.updateValue(groupMessages, forKey: title)
                }
            }
            handler(feedMessages, groupWithMessagesDict)
        }
    }
    
    
    func getEmail(forSeachQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        refUsers.observe(.value) { (userDataSnapshot) in
            guard let userDataSnapshot = userDataSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userDataSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getEmailsForGroup(_ group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        refUsers.observeSingleEvent(of: .value) { (userDataSnapshot) in
            guard let userDataSnapshot = userDataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userDataSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        refUsers.observeSingleEvent(of: .value) { (userDataSnapshot) in
            var idArray = [String]()
            guard let userDataSnapshot = userDataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userDataSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        refGroups.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        refGroups.observeSingleEvent(of: .value) { (groupDataSnapshot) in
            guard let groupDataSnapshot = groupDataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupDataSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    
                    let group = Group(groupTtile: title, groupDescription: description, key: group.key, memberCount: memberArray.count, members: memberArray)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
}
