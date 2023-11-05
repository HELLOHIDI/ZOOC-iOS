//
//  UIImage.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/12.
//

import UIKit

//MARK: - 해당 Enum은 asset에 저장된 이미지와 이름이 동일해야 합니다!
public enum ZwImageName: String {
    
    case ic_back
    case ic_cart
    case ic_explore_active
    case ic_explore_inactive
    case ic_home_active
    case ic_home_inactive
    case ic_info
    case ic_inquiry
    case ic_logout
    case ic_my_active
    case ic_my_inactive
    case ic_notice
    case ic_orderlist
    case ic_settings
    case ic_warning
}

//MARK: - 사용할땐

extension UIImage {
    
    static func zwImage(_ imageName: ZwImageName) -> UIImage {
        return UIImage(named: imageName.rawValue)!
    }
}

extension UIImage{
    
    class func zoocEmoji(_ id: Int) -> UIImage{
        switch id{
        case 0: return Image.emojiDancing
        case 1: return Image.emojiHeart
        case 2: return Image.emojiSmile
        case 3: return Image.emojiSad
        case 4: return Image.emojiThumb
        case 5: return Image.emojiSurprise
        case 6: return Image.emojiHug
        case 7: return Image.emojiDog
        default: return UIImage()
        }
    }
}
