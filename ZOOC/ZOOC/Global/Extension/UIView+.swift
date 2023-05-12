//
//  UIView+.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

extension UIView {
    func addSubviews (_ views: UIView...){
        views.forEach { self.addSubview($0) }
    }
    
    func makeShadow (
        color: UIColor,
        offset : CGSize,
        radius : CGFloat,
        opacity : Float)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func makeCornerRound (radius: CGFloat){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func makeCornerRound (ratio : CGFloat) {
        layer.cornerRadius = self.frame.height / ratio
        layer.masksToBounds = true
    }
    
    func makeCornerBorder (borderWidth: CGFloat, borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

