//
//  UIFont+.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

//MARK: - Custom Font

extension UIFont {
    
    static var zoocDisplay2: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 28)!
    }
    
    static var zoocDisplay1: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 24)!
    }
    
    static var zoocHeadLine: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 20)!
    }
    
    static var zoocSubhead2: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 18)!
    }
   
    static var zoocSubhead1: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 16)!
    }
    
    static var zoocBody3: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 16)!
    }
    
    static var zoocBody2: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 15)!
    }
    
    static var zoocBody1: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 14)!
    }
    
    static var zoocCaption: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 12)!
    }
    
    static var zoocSmallCaption: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 10)!
    }
    
    static func zoocFont(font: Pretendard, size: CGFloat) -> UIFont {
        return UIFont(name: font.name, size: size)!
    }
    
    
    enum Pretendard {
        case regular
        case medium
        case semiBold
        case bold
        
        var name: String {
            switch self {
            case .regular:
                return "Pretendard-Regular"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .bold:
                return "Pretendard-Bold"
            }
        }
    }
    
}
