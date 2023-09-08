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
    
    static var zoocBackgroundGreen: CGColor {
        return CGColor(red: CGFloat(240)/255, green: CGFloat(242)/255, blue: CGFloat(239)/255, alpha: 1)
    }
    static var zoocGray1: CGColor {
        return CGColor(red: CGFloat(189)/255, green: CGFloat(189)/255, blue: CGFloat(189)/255, alpha: 1)
    }
    
    static var zoocGradientGreenFirst: CGColor {
        return CGColor(red: CGFloat(66)/255, green: CGFloat(200)/255, blue: CGFloat(144)/255, alpha: 1)
    }
    
    static var zoocGradientGreenLast: CGColor {
        return CGColor(red: CGFloat(59)/255, green: CGFloat(183)/255, blue: CGFloat(116)/255, alpha: 1)
    }
    
}
