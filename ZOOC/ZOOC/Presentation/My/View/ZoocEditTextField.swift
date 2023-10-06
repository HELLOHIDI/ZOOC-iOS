//
//  MyEditTextField.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

protocol MyTextFieldDelegate: AnyObject {
    func myTextFieldTextDidChange(_ textFieldType: ZoocEditTextField.TextFieldType, text: String)
}

class ZoocEditTextField : BaseTextField {
    
    enum TextFieldType {
        case profile
        case pet
        case familyCode
        
        var limit: Int {
            switch self {
            case .profile: return 10
            case .pet: return 4
            case .familyCode: return 6
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

extension ZoocEditTextField: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return}
        editDelegate?.myTextFieldTextDidChange(textFieldType, text: text)
    }
}
