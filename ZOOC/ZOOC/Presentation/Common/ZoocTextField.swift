//
//  ZoocTextField.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

protocol ZoocTextFieldDelegate: AnyObject {
    func authTextFieldTextDidChange(_ textField: ZoocTextField, text: String)
    func authTextFieldDidReturn(_ textField: ZoocTextField)
}

final class ZoocTextField : UITextField {
    
    //MARK: - Properties
    
    weak var zoocDelegate: ZoocTextFieldDelegate?
    
    
    //MARK: - UI Components
    
    //MARK: - Life Cycle
    
    init(_ keyboardType: UIKeyboardType) {
        super.init(frame: .zero)
        
        self.keyboardType = keyboardType
        
        delegate()
        style()
        updateEditingUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        delegate = self
    }
    
    private func style() {
        self.autocapitalizationType = .none
        self.backgroundColor = .white
        self.addLeftPadding(inset: 10)
        self.makeCornerRound(radius: 7)
    }
    
    private func updateEditingUI() {
        let color: UIColor = isEditing ? .zoocMainGreen : .zoocLightGray
        setBorder(borderWidth: 1, borderColor: color)
    }
    
    //MARK: - Public Method
    
    
    //MARK: - Action Method
}

//MARK: - UITextFieldDelegate

extension ZoocTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateEditingUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        zoocDelegate?.authTextFieldDidReturn(self)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateEditingUI()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return}
        zoocDelegate?.authTextFieldTextDidChange(self, text: text)
    }

}

