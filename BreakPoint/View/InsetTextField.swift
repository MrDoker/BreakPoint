//
//  InsetTextField.swift
//  BreakPoint
//
//  Created by DokeR on 12.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

//@IBDesignable
class InsetTextField: UITextField {

    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }
    
    /*override func prepareForInterfaceBuilder() {
        setupView()
        super.prepareForInterfaceBuilder()
    }*/
    
    func setupView() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        self.attributedPlaceholder = placeholder
    }

}
