//
//  DesignableTextField.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import Foundation
import UIKit

class DesignableUITextField: UITextField {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    private var dynamicPadding: UIEdgeInsets {
        var padding: UIEdgeInsets
        if screenSize.height < 700 {
            padding = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40)
        } else {
            padding = UIEdgeInsets(top: 10, left: 45, bottom: 10, right: 45)
        }
        
        return padding
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: dynamicPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: dynamicPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: dynamicPadding)
    }
}
