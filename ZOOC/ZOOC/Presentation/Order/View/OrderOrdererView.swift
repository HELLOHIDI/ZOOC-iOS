//
//  OredererView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit

protocol OrderOrdererViewDelegate: AnyObject {
    func textFieldDidEndEditing(name: String?, phoneNumber: String?)
}

final class OrderOrdererView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderOrdererViewDelegate?
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "구매자 정보"
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private lazy var foldButton: UIButton = {
        let button = UIButton()
        button.tintColor = .zoocDarkGray1
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .selected)
        button.addTarget(self,
                         action: #selector(foldButtonDidTap),
                         for: .touchUpInside)
        button.isHidden = true //TODO: - 추후 폴더블한 애니메이션 구현
        return button
    }()
    
    private let nameLabel = ZoocRequiredInputLabel.init(text: "구매자")
    
    private let nameTextField: ZoocTextField = {
        let textField = ZoocTextField(.default)
        textField.font = .zoocBody1
        textField.textAlignment = .left
        textField.textColor = .zoocGray3
        textField.placeholder = "실명"
        textField.addLeftPadding(inset: 18)
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    private let phoneNumberLabel = ZoocRequiredInputLabel.init(text: "연락처")
    
    private let phoneNumberTextField: ZoocTextField = {
        let textField = ZoocTextField(.numberPad)
        textField.font = .zoocBody1
        textField.textAlignment = .left
        textField.textColor = .zoocGray3
        textField.placeholder = "010 - 1234 -5678"
        textField.addLeftPadding(inset: 18)
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        headerView.addSubviews(titleLabel, foldButton)
        
        addSubviews(headerView, mainView)
        
        mainView.addSubviews(nameLabel,
                             nameTextField,
                             phoneNumberLabel,
                             phoneNumberTextField)
        
    }
    
    private func layout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
        }
        
        foldButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(100)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameTextField)
            $0.leading.equalToSuperview().inset(30)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.trailing.height.equalTo(nameTextField)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(phoneNumberTextField)
            $0.leading.equalToSuperview().inset(30)
        }
        
    }
    
    private func setDelegate() {
        nameTextField.zoocDelegate = self
        phoneNumberTextField.zoocDelegate = self
    }
    
    func updateUI(_ data: OrderOrderer) {
        nameTextField.text = data.name
        phoneNumberTextField.text = data.phoneNumber
    }
    
    func checkValidity() throws {
        
        nameTextField.updateInvalidUI()
        phoneNumberTextField.updateInvalidUI()
        
        guard nameTextField.hasText,
              phoneNumberTextField.hasText else {
            throw OrderInvalidError.ordererInvalid
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func foldButtonDidTap() {
        foldButton.isSelected.toggle()
    }
    
}

extension OrderOrdererView: ZoocTextFieldDelegate {
    
    func zoocTextFieldDidReturn(_ textField: ZoocTextField) {
        if textField == nameTextField {
            phoneNumberTextField.becomeFirstResponder()
        }
    }
    
    func zoocTextFieldDidEndEditing(_ textField: ZoocTextField) {
        delegate?.textFieldDidEndEditing(name: nameTextField.text,
                                         phoneNumber: phoneNumberTextField.text)
    }
}


