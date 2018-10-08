//
//  MyMessagesCell.swift
//  BreakPoint
//
//  Created by DokeR on 04.10.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class MyMessagesCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCellWith(_ content: String) {
        contentLabel.text = content
    }

}
