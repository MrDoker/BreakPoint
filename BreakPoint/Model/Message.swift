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
