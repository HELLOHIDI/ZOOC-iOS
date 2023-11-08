//
//  MyEditTextField.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit
enum TextFieldType {
    case profile
    case breed
    
    var limit: Int {
        switch self {
        case .profile: return 5
        case .breed: return 20
        }
    }
}

enum TextFieldState {
    case empty
    case editing
    case exceed
    
    var currentTextColor: UIColor {
        switch self{
        case .empty:
            return .zw_lightgray
        case .editing:
            return .zw_point
        case .exceed:
            return .zw_point
        }
    }
    
    var limitTextColor: UIColor {
        switch self{
        case .empty:
            return .zw_lightgray
        case .editing:
            return .zw_lightgray
        case .exceed:
            return .zw_point
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .empty:
            return .zw_lightgray
        case .editing:
            return .zw_point
        case .exceed:
            return .zw_point
        }
    }
}

class ZoocEditTextField: BaseTextField {
    
    
    var textFieldType: TextFieldType
    var textFieldState: TextFieldState
    
    let characterCountLabel = UILabel()
    let currentTextCnt = 0
    
    init(textFieldType: TextFieldType, textFieldState: TextFieldState = .empty) {
        self.textFieldType = textFieldType
        self.textFieldState = textFieldState
        super.init(frame: .zero)
        
        setStyle()
        setRightView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 20
        
        return padding
    }
    
    private func setStyle() {
        self.do {
            $0.addLeftPadding(inset: 20)
            $0.font = .zw_Body1
            $0.textColor = .zw_black
            $0.setBorder(borderWidth: 1, borderColor: .zw_brightgray)
        }
    }
    private func setRightView() {
        characterCountLabel.do {
            $0.text = "\(self.currentTextCnt)/\(self.textFieldType.limit)"
            $0.textColor = .zw_lightgray
            $0.textAlignment = .center
            $0.font = .price_small
        }
        
        self.rightView = characterCountLabel
        self.rightViewMode = .always
    }
}

extension ZoocEditTextField {
    func updateTextField(_ currentText: String) {
        let limit = self.textFieldType.limit
        
        switch currentText.count {
        case 0:
            self.textFieldState = .empty
            self.characterCountLabel.text = "\(currentText.count)/\(limit)"
        case textFieldType.limit...:
            self.textFieldState = .exceed
            let fixedText = self.text?.substring(
                from: 0,
                to: self.textFieldType.limit-1
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.text = fixedText
                self.characterCountLabel.text = "\(limit)/\(limit)"
            }
        default:
            self.textFieldState = .editing
            self.characterCountLabel.text = "\(currentText.count)/\(limit)"
        }
        
        self.characterCountLabel.textColor = textFieldState.limitTextColor
        self.characterCountLabel.asColor(targetString: "\(currentText.count)", color: textFieldState.currentTextColor)
        self.layer.borderColor = textFieldState.borderColor.cgColor
    }
}
