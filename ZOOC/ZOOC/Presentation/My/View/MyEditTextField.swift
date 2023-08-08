//
//  MyEditTextField.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

protocol MyTextFieldDelegate: AnyObject {
    func myTextFieldTextDidChange(_ textFieldType: MyEditTextField.TextFieldType, text: String)
}

final class MyEditTextField : UITextField {
    
    enum TextFieldType {
        case profile
        case pet
        
        var limit: Int {
            switch self {
            case .profile: return 10
            case .pet: return 4
            }
        }
    }
    
    public var textFieldType: TextFieldType
    weak var editDelegate: MyTextFieldDelegate?
    
    init(textFieldType: TextFieldType) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        
        delegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func delegate() {
        delegate = self
    }
}

extension MyEditTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//            updateEditingUI()
        }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let text = textField.text else { return}
//            updateClearButtonUI()
            editDelegate?.myTextFieldTextDidChange(textFieldType, text: text)
        }
}
    
