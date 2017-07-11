//
//  customButton.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 11/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit

@IBDesignable class customButton: UIButton {

    @IBInspectable var CRadius : CGFloat = 0 {
        didSet {
        
        layer.cornerRadius = self.CRadius
        }
    
    }


}
