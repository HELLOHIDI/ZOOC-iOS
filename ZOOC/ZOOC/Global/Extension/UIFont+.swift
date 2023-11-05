//
//  UIFont+.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

//MARK: - Custom Font

extension UIFont {
    
    enum Pretendard: String {
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
    }
    
    enum Gmarket: String {
        case bold = "GmarketSansBold"
        case medium = "GmarketSansMedium"
        case light = "GmarketSansLight"
    }
    
    // 디자인 시스템이 적용되지 않은 건 아래 함수 사용하세용
    static func pretendardFont(font: Pretendard, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size)!
    }
    
    static func gmarketFont(font: Gmarket, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size)!
    }
    
    
    // 디자인 시스템 적용된건 아래 프로퍼티 사용하세용
    static var zw_head1: UIFont {
        return UIFont(name: Pretendard.semiBold.rawValue, size: 20)!
    }
    
    static var zw_Subhead1: UIFont {
        return UIFont(name: Pretendard.semiBold.rawValue, size: 18)!
    }
    
    static var zw_Subhead2: UIFont {
        return UIFont(name: Pretendard.medium.rawValue, size: 18)!
    }
    
    static var zw_Subhead3: UIFont {
        return UIFont(name: Pretendard.semiBold.rawValue, size: 16)!
    }
    
    static var zw_Subhead4: UIFont {
        return UIFont(name: Pretendard.medium.rawValue, size: 14)!
    }
    
    static var zw_Body1: UIFont {
        return UIFont(name: Pretendard.regular.rawValue, size: 16)!
    }
    
    static var zw_Body2: UIFont {
        return UIFont(name: Pretendard.regular.rawValue, size: 14)!
    }
    
    static var zw_caption: UIFont {
        return UIFont(name: Pretendard.semiBold.rawValue, size: 28)!
    }
    
    static var price_big: UIFont {
        return UIFont(name: Pretendard.semiBold.rawValue, size: 28)!
    }
    
    static var price_middle: UIFont {
        return UIFont(name: Pretendard.semiBold.rawValue, size: 28)!
    }
    
    static var price_small: UIFont {
        return UIFont(name: Pretendard.semiBold.rawValue, size: 28)!
    }

    
}

//MARK: - Deprecated

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
    
    
}
