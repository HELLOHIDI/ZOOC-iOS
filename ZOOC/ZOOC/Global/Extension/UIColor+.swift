//
//  UIColor+.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r)/255,green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}

//MARK: - Custom Color

extension UIColor{
    
    //MARK: Brand Colors
    static var zoocMainGreen: UIColor {
        return UIColor(r: 66, g: 200, b: 127)
    }
    
    static var zoocSubGreen: UIColor {
        return UIColor(r: 104, g: 212, b: 154)
    }
    
    static var zoocGradientGreen: UIColor {
        return UIColor(r: 104, g: 212, b: 154)   
    }
    
    //MARK: Gray Scale Colors
    
    static var zoocWhite1: UIColor {
        return UIColor(r: 255, g: 255, b: 255)
    }
    
    static var zoocWhite2: UIColor {
        return UIColor(r: 248, g: 248, b: 248)
    }
    
    static var zoocWhite3: UIColor {
        return UIColor(r: 242, g: 242, b: 242)
    }
    
    static var zoocLightGray: UIColor {
        return UIColor(r: 224, g: 224, b: 224)
    }
    
    static var zoocGray1: UIColor {
        return UIColor(r: 189, g: 189, b: 189)
    }
    
    static var zoocGray2: UIColor {
        return UIColor(r: 130, g: 130, b: 130)
    }
    
    static var zoocGray3: UIColor {
        return UIColor(r: 85, g: 85, b: 85)
    }
    
    static var zoocDarkGray1: UIColor {
        return UIColor(r: 79, g: 79, b: 79)
    }
    
    static var zoocDarkGray2: UIColor {
        return UIColor(r: 51, g: 51, b: 51)
    }
    
    //MARK: Green Scale Colors
    
    static var zoocBackgroundGreen: UIColor {
        return UIColor(r: 240, g: 242, b: 239)
    }
    
    static var zoocLightGreen: UIColor {
        return UIColor(r: 222, g: 227, b: 219)
    }
    
    static var zoocDarkGreen: UIColor {
        return UIColor(r: 136, g: 140, b: 134)
    }
    
    static var zoocShadowGreenColor: UIColor {
        return UIColor(r: 119, g: 184, b: 149)
    }
    
    //MARK: - Toast Color
    
    static var zoocRed: UIColor {
        return UIColor(r: 253, g: 73, b: 73)
    }
}
