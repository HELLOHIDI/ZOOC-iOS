//
//  Direction+.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/04.
//

import UIKit

extension UISwipeGestureRecognizer.Direction {
    func transform() -> HorizontalSwipe {
        switch self {
        case .left: return .left
        case .right: return .right
        default: return .left
        }
    }
}
