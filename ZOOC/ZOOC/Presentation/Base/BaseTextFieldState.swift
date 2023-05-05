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
    
    var buttonColor: UIColor {
        switch self {
        case .isFull:
            return .zoocGradientGreen
        case .isEmpty:
            return .zoocGray1
        case .isWritten:
            return .zoocGradientGreen
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .isFull:
            return true
        case .isEmpty:
            return false
        case .isWritten:
            return true
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
                           button: UIButton?,
                           label: UILabel?,
                           indexScope: String?) {
        underLineView?.backgroundColor = self.backgroundColor
        textField?.textColor = self.textColor
        button?.backgroundColor = self.buttonColor
        button?.isEnabled = self.isEnabled
        label?.asColor(targetString: indexScope ?? "", color: self.indexColor)
    }
}
