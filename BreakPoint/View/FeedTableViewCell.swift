//
//  FeedTableViewCell.swift
//  BreakPoint
//
//  Created by DokeR on 17.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configCell(email: String, message: String) {
        emailLabel.text = email
        messageLabel.text = message
    }

}
