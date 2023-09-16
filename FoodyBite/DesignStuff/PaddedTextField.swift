//
//  PaddedTextField.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 30.10.23.
//

import Foundation
import UIKit

class PaddedTextField: UITextField {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    private var dynamicPadding: UIEdgeInsets {
        var padding: UIEdgeInsets
        if screenSize.height < 700 {
            padding = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        } else {
            padding = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
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
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0))
    }
}
