//
//  UIButton+.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/10.
//

import UIKit
import Kingfisher

extension UIButton {
//    
//    open override var backgroundColor: UIColor? {
//        didSet{
//            
//            if backgroundColor == .zoocGradientGreen {
//                print("didSet들어옴")
//                let gradientLayer = CAGradientLayer()
//                //66 200 127
//                var colors:[CGColor] = [.init(red: CGFloat(0)/255, green: CGFloat(0)/255, blue: CGFloat(0)/255, alpha: 1),
//                                        .init(red: CGFloat(59)/255, green: CGFloat(188)/255, blue: CGFloat(116)/255, alpha: 1)]
//                
//                gradientLayer.frame = self.bounds
//                gradientLayer.colors = colors
//                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//                self.layer.addSublayer(gradientLayer)
//                
//                self.layoutIfNeeded()
//            } else {
//                //self.layer.removeFromSuperlayer()
//            }
//            
//        }
//    }
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    
    func kfSetButtonImage(url : String) {
        if let url = URL(string: url) {
            kf.setImage(with: url,
                        for: .normal, placeholder: nil,
                        options: [.transition(.fade(1.0))], progressBlock: nil)
        }
    }
}





