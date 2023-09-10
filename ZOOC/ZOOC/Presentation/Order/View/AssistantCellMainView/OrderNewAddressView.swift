//
//  OrderNewAddressView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/04.
//

import UIKit

import SnapKit

protocol OrderNewAddressViewDelegate: AnyObject {
    func findAddressButtonDidTap()
    func textFieldDidEndEditing(addressName: String,
                                receiverName: String,
                                receiverPhoneNumber: String,
                                detailAddress: String?,
                                request: String?)
}

final class OrderNewAddressView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderNewAddressViewDelegate?
    
    //MARK: - UI Components
    
    private let receiverLabel = ZoocRequiredInputLabel.init(text: "수령인")

    private let receiverTextField: ZoocTextField = {
        let textField = ZoocTextField()
        textField.placeholder = "실명"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    private let phoneNumberLabel = ZoocRequiredInputLabel.init(text: "연락처")
    
    private let receiverPhoneNumberTextField: ZoocTextField = {
        let textField = ZoocTextField(.numberPad)
        textField.placeholder = "010 - 1234 - 5678"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    
    private let addressLabel = ZoocRequiredInputLabel.init(text: "배송지")
    
    private let postCodeLabelBox: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.backgroundColor = .zoocWhite2
        label.textColor = .zoocGray1
        label.font = .zoocBody1
        label.setBorder(borderWidth: 1, borderColor: .zoocLightGray)
        label.makeCornerRound(radius: 7)
        return label
    }()
    
    private lazy var findAddressButton: ZoocGradientButton = {
        let button = ZoocGradientButton.init(.order)
        button.setTitle("주소 검색", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)!
        button.addTarget(self,
                         action: #selector(findAddressButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let addressLabelBox: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.textColor = .zoocGray1
        label.backgroundColor = .zoocWhite2
        label.font = .zoocBody1
        label.setBorder(borderWidth: 1, borderColor: .zoocLightGray)
        label.makeCornerRound(radius: 7)
        label.numberOfLines = 0
        return label
    }()
    
    private let detailAddressTextField: ZoocTextField = {
        let textField = ZoocTextField(.default)
        textField.placeholder = "상세주소"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    
    private let requestLabel: UILabel = {
        let label = UILabel()
        label.text = "요청사항"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let requestTextField: ZoocTextField = {
        let textField = ZoocTextField(.default)
        textField.placeholder = "부재 시 경비실에 맡겨주세요"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    lazy var registerBasicAddressCheckButton: UIButton = {
        let button = UIButton()
        button.isSelected = true
        button.setImage(Image.checkBox, for: .normal)
        button.setImage(Image.checkBoxFill, for: .selected)
        button.setImage(Image.checkBoxRed, for: .highlighted)
        button.addTarget(self,
                         action: #selector(checkButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let registerBasicAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "기존 배송지로 등록"
        label.font = .zoocBody1
        label.textAlignment = .left
        label.textColor = .zoocGray2
        return label
    }()
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        setTag()
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
        
        self.addSubviews(postCodeLabelBox,
                         receiverLabel,
                         receiverTextField,
                         phoneNumberLabel,
                         receiverPhoneNumberTextField,
                         addressLabel,
                         findAddressButton,
                         addressLabelBox,
                         detailAddressTextField,
                         registerBasicAddressCheckButton,
                         registerBasicAddressLabel,
                         requestLabel,
                         requestTextField)
        
    }
    
    private func layout() {
        receiverTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(97)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        receiverLabel.snp.makeConstraints {
            $0.centerY.equalTo(receiverTextField)
            $0.leading.equalToSuperview().inset(30)
        }
        
        receiverPhoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(receiverTextField.snp.bottom).offset(12)
            $0.leading.trailing.height.equalTo(receiverTextField)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(receiverPhoneNumberTextField)
            $0.leading.equalToSuperview().inset(30)
        }
        
        postCodeLabelBox.snp.makeConstraints {
            $0.top.equalTo(receiverPhoneNumberTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(97)
            $0.trailing.equalToSuperview().inset(134)
            $0.height.equalTo(41)
        }
        
        addressLabel.snp.makeConstraints {
            $0.centerY.equalTo(postCodeLabelBox)
            $0.leading.equalToSuperview().inset(30)
        }
        
        findAddressButton.snp.makeConstraints {
            $0.top.height.equalTo(postCodeLabelBox)
            $0.leading.equalTo(postCodeLabelBox.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        addressLabelBox.snp.makeConstraints {
            $0.top.equalTo(findAddressButton.snp.bottom).offset(12)
            $0.leading.height.equalTo(postCodeLabelBox)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        detailAddressTextField.snp.makeConstraints {
            $0.top.equalTo(addressLabelBox.snp.bottom).offset(12)
            $0.leading.height.equalTo(postCodeLabelBox)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        registerBasicAddressCheckButton.snp.makeConstraints {
            $0.top.equalTo(detailAddressTextField.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(97)
            $0.size.equalTo(20)
        }
        
        registerBasicAddressLabel.snp.makeConstraints {
            $0.centerY.equalTo(registerBasicAddressCheckButton)
            $0.leading.equalTo(registerBasicAddressCheckButton.snp.trailing).offset(10)
        }
        
        requestLabel.snp.makeConstraints {
            $0.centerY.equalTo(requestTextField)
            $0.leading.equalToSuperview().inset(30)
        }
        
        requestTextField.snp.makeConstraints {
            $0.top.equalTo(registerBasicAddressCheckButton.snp.bottom).offset(12)
            $0.leading.trailing.height.equalTo(addressLabelBox)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setTag() {
        receiverTextField.tag = 1
        receiverPhoneNumberTextField.tag = 2
        detailAddressTextField.tag = 3
        requestTextField.tag = 4
    }
    
    private func setDelegate() {
        receiverTextField.zoocDelegate = self
        receiverPhoneNumberTextField.zoocDelegate = self
        detailAddressTextField.zoocDelegate = self
        requestTextField.zoocDelegate = self
    }
    
    func updateUI(_ data: OrderAddress, isPostData: Bool = false) {
        receiverTextField.text = data.receiverName
        receiverPhoneNumberTextField.text = data.receiverPhoneNumber
        postCodeLabelBox.text = data.postCode
        addressLabelBox.text = data.address
        detailAddressTextField.text = data.detailAddress
        
        if isPostData {
            postCodeLabelBox.textColor = .zoocGray3
            addressLabelBox.textColor = .zoocGray3
            detailAddressTextField.becomeFirstResponder()
        } else {
            postCodeLabelBox.text = "우편번호"
            addressLabelBox.text = "주소"
        }
        
    }
    
    func checkValidity() throws {
        receiverTextField.updateInvalidUI()
        receiverPhoneNumberTextField.updateInvalidUI()
        if postCodeLabelBox.text == "우편번호" { addressLabel.textColor = .red}
        else { addressLabel.textColor = .zoocGray2 }
        
        if addressLabelBox.text == "주소" { addressLabel.textColor = .red}
        else { addressLabel.textColor = .zoocGray2 }
        
        guard receiverTextField.hasText,
              receiverPhoneNumberTextField.hasText,
              postCodeLabelBox.text != "우편번호",
              addressLabelBox.text != "주소" else {
            print("🍏🍏🍏🍏🍏🍏🍏🍏🍏🍏")
            throw OrderInvalidError.addressInvlid
        }
    }
    
    @objc
    private func checkButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc
    private func findAddressButtonDidTap() {
        endEditing(true)
        delegate?.findAddressButtonDidTap()
    }
}

extension OrderNewAddressView: ZoocTextFieldDelegate {
    
    func zoocTextFieldDidReturn(_ textField: ZoocTextField) {
        resignFirstResponder()
        switch textField.tag {
        case 0:
            receiverTextField.becomeFirstResponder()
        case 1:
            receiverPhoneNumberTextField.becomeFirstResponder()
        case 2:
            detailAddressTextField.becomeFirstResponder()
        case 3:
            requestTextField.becomeFirstResponder()
        default:
            return
        }
    }
    
    func zoocTextFieldDidEndEditing(_ textField: ZoocTextField) {
        delegate?.textFieldDidEndEditing(addressName: addressLabelBox.text ?? "",
                                         receiverName: receiverTextField.text ?? "",
                                         receiverPhoneNumber: receiverPhoneNumberTextField.text ?? "",
                                         detailAddress: detailAddressTextField.hasText ? detailAddressTextField.text : nil,
                                         request: detailAddressTextField.hasText ? requestTextField.text : nil)
    }
}
