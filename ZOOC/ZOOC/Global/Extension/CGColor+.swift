//
//  CGColor+.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/14.
//

import UIKit

//MARK: - Custom Color

extension CGColor{
    
    //MARK: Brand Colors
    static var zoocGray1: CGColor {
        return CGColor(red: CGFloat(189)/255, green: CGFloat(189)/255, blue: CGFloat(189)/255, alpha: 1)
    }
    
    static var zoocGradientGreenFirst: CGColor {
        return CGColor(red: CGFloat(6)/255, green: CGFloat(2)/255, blue: CGFloat(127)/255, alpha: 1)
    }
    
    static var zoocGradientGreenLast: CGColor {
        return CGColor(red: CGFloat(59)/255, green: CGFloat(188)/255, blue: CGFloat(116)/255, alpha: 1)
    }
    
}
