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
    
    func configCell(profileImage: UIImage, email: String, content: String) {
        profileImageView.image = profileImage
        emailLabel.text = email
        contentLabel.text = content
    }
    

}
