//
//  GroupFeedCell.swift
//  BreakPoint
//
//  Created by DokeR on 20.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var sendDateLabel: UILabel!
    
    @IBOutlet weak var emailHeightConstraint: NSLayoutConstraint!
    
    
    func configCell(profileImageURL: String, email: String, content: String, sendDate: String) {
     profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
        emailLabel.text = email
        contentLabel.text = content
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "yyyy, MMM d, HH:mm:ss"
        
        if let newDate = newFormatter.date(from: sendDate) {
            newFormatter.dateFormat = "MMM d, HH:mm"
            sendDateLabel.text = newFormatter.string(from: newDate)
        }
        
    }

}
