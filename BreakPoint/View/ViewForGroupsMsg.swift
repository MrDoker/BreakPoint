//
//  ViewForGroupsMsg.swift
//  BreakPoint
//
//  Created by DokeR on 08.10.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

@IBDesignable
class ViewForGroupsMsg: UIView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
    }

}
