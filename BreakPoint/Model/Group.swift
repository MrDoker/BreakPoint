//
//  Group.swift
//  BreakPoint
//
//  Created by DokeR on 19.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import Foundation

class Group {
    public private(set) var groupTtile: String
    public private(set) var groupDescription: String
    public private(set) var key: String
    public private(set) var memberCount: Int
    public private(set) var members: [String]
    
    init(groupTtile: String, groupDescription: String, key: String, memberCount: Int, members: [String]) {
        self.groupTtile = groupTtile
        self.groupDescription = groupDescription
        self.key = key
        self.memberCount = memberCount
        self.members = members
    }
    
}
