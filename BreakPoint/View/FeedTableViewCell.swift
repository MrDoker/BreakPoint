//
//  FeedTableViewCell.swift
//  BreakPoint
//
//  Created by DokeR on 17.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configCell(profileImage: UIImage, email: String, message: String) {
        profileImageView.image = profileImage
        emailLabel.text = email
        messageLabel.text = message
    }

}
