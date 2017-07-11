//
//  customView.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 11/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit

@IBDesignable class customView: UIView {

    @IBInspectable var cRadius: CGFloat = 0
    @IBInspectable var SO_Width: CGFloat = 0
    @IBInspectable var SO_Height: CGFloat = 5
    @IBInspectable  var SO_Color : UIColor = UIColor.black
    @IBInspectable var SO_Opacity : Float = 0
//    didSet{
//    
//     layer.cornerRadius = self.cRadius
//    
//    }
    
    override func layoutSubviews() {
        layer.cornerRadius = self.cRadius
        layer.shadowOffset = CGSize(width: SO_Width, height: SO_Height)
        layer.shadowColor = SO_Color.cgColor
        
       let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cRadius)
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = SO_Opacity
    }

}
