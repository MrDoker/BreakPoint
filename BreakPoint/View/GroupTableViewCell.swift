//
//  GroupTableViewCell.swift
//  BreakPoint
//
//  Created by DokeR on 19.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    func configCell(title: String, description: String, memberCount: Int) {
        groupTitleLabel.text = title
        groupDescriptionLabel.text = description
        memberCountLabel.text = "\(memberCount) members."
    }
    
}
