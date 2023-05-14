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
    
    func setZoocGradientColor() {
        let gradientLayer = CAGradientLayer()
        var colors: [CGColor] = [.init(red: 66/255, green: 200/255, blue: 127/255, alpha: 1),
                                 .init(red: 59/255, green: 188/255, blue: 116/255, alpha: 1)]
        colors = [.init(red: CGFloat(66)/255, green: CGFloat(200)/255, blue: CGFloat(127)/255, alpha: 1),
                                 .init(red: CGFloat(59)/255, green: CGFloat(188)/255, blue: CGFloat(116)/255, alpha: 1)]
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        self.layer.addSublayer(gradientLayer)
    }
}

