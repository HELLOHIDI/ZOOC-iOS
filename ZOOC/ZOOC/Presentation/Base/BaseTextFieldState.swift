//
//  BaseTextFieldState.swift
//  ZOOC
//
//  Created by 류희재 on 2023/02/26.
//

import UIKit

enum BaseTextFieldState {
    case isFull
    case isEmpty
    case isWritten
    
    var backgroundColor: UIColor {
        switch self {
        case .isFull:
            return .zoocGradientGreen
        case .isEmpty:
            return .zoocGray1
        case .isWritten:
            return .zoocGradientGreen
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .isFull:
            return .zoocDarkGreen
        case .isEmpty:
            return .zoocGray1
        case .isWritten:
            return .zoocDarkGreen
        }
    }
    
    var indexColor: UIColor {
        switch self {
        case .isFull:
            return .zoocGradientGreen
        case .isEmpty:
            return .zoocGray1
        case .isWritten:
            return .zoocGradientGreen
        }
    }
    
    func setTextFieldState(textField: UITextField?,
                           underLineView: UIView?,
                           label: UILabel?) {
        underLineView?.backgroundColor = self.backgroundColor
        textField?.textColor = self.textColor
        label?.textColor = self.indexColor
    }
}
