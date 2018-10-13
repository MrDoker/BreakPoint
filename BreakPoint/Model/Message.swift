//
//  Message.swift
//  BreakPoint
//
//  Created by DokeR on 17.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import Foundation

class Message {
    public private(set) var content: String
    public private(set) var senderId: String
    
    init(content: String, senderId: String) {
        self.content = content
        self.senderId = senderId
    }
    
}

class NewMessage {
    public private(set) var content: String
    public private(set) var senderEmail: String
    public private(set) var senderImageURL: String
    public private(set) var key: String
    public private(set) var senderID: String
    public private(set) var sendDate: String
    
    init(content: String, senderEmail: String, senderImageURL: String, key: String, senderID: String, sendDate: String) {
        self.content = content
        self.senderEmail = senderEmail
        self.senderImageURL = senderImageURL
        self.key = key
        self.senderID = senderID
        self.sendDate = sendDate
    }
    
    init(content: String) {
        self.content = content
        self.senderEmail = "senderEmail"
        self.senderImageURL = "senderImageURL"
        self.key = "key"
        self.senderID = "senderID"
        self.sendDate = "sendDate"
    }
    
}
