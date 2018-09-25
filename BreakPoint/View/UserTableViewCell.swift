//
//  UserTableViewCell.swift
//  BreakPoint
//
//  Created by DokeR on 19.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkImageView.isHidden.toggle()
        }
    }
    
    func configCell(profileImageURL: String, email: String, isSelected: Bool) {
        profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
        emailLabel.text = email
        
        if isSelected {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
    }
    
    /*
    func configCell(profileImage: UIImage, email: String, isSelected: Bool) {
        profileImageView.image = profileImage
        emailLabel.text = email
        
        if isSelected {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
    }
     */
}
