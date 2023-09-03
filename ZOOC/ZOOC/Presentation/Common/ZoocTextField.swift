//
//  ZoocTextField.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

@objc protocol ZoocTextFieldDelegate: UITextFieldDelegate {
    @objc optional func zoocTextFieldTextDidChange(_ textField: ZoocTextField, text: String)
    @objc optional func zoocTextFieldDidReturn(_ textField: ZoocTextField)
    @objc optional func zoocTextFieldDidEndEditing(_ textField: ZoocTextField)
}

extension ZoocTextFieldDelegate {
    
}

final class ZoocTextField: UITextField {
    
    //MARK: - Properties
    
    weak var zoocDelegate: ZoocTextFieldDelegate?
    
    //MARK: - UI Components
    
    //MARK: - Life Cycle
    
    init(_ keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        
        self.keyboardType = keyboardType
        
        delegate()
        style()
        updateEditingUI()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Method
    
    private func delegate() {
        delegate = self
    }
    
    private func style() {
        self.autocapitalizationType = .none
        self.returnKeyType = .done
        self.backgroundColor = .white
        self.addLeftPadding(inset: 18)
        self.makeCornerRound(radius: 7)
        
    }
    
    private func updateEditingUI() {
        let color: UIColor = isEditing ? .zoocMainGreen : .zoocLightGray
        setBorder(borderWidth: 1, borderColor: color)
    }
    
    //MARK: - Public Method
    
    func updateInvalidUI() {
        guard let text else { return }
        let color: UIColor = text.hasText ? .zoocLightGray : .red
        setBorder(borderWidth: 1, borderColor: color)
    }
    
    
    //MARK: - Action Method
}

//MARK: - UITextFieldDelegate

extension ZoocTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateEditingUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        zoocDelegate?.zoocTextFieldDidReturn?(self)
        endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateEditingUI()
        zoocDelegate?.zoocTextFieldDidEndEditing?(self)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        zoocDelegate?.zoocTextFieldTextDidChange?(self, text: text)
    }

}

