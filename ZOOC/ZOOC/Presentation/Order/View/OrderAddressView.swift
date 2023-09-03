//
//  AddressView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit

protocol OrderAddressViewDelegate: AnyObject {
    func findAddressButtonDidTap()
    func copyButtonDidTap()
    func textFieldDidEndEditing(addressName: String,
                                receiverName: String,
                                receiverPhoneNumber: String,
                                detailAddress: String?,
                                request: String?)
}

final class OrderAddressView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAddressViewDelegate?
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "배송 정보"
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매자와 동일해요", for: .normal)
        button.setUnderline()
        button.setTitleColor(.zoocGray1, for: .normal)
        button.titleLabel?.font = .zoocBody2
        button.addTarget(self,
                         action: #selector(copyButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let receiverLabel: UILabel = {
        let label = UILabel()
        label.text = "수령인"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let receiverTextField: ZoocTextField = {
        let textField = ZoocTextField()
        textField.placeholder = "실명"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "연락처"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let receiverPhoneNumberTextField: ZoocTextField = {
        let textField = ZoocTextField(.numberPad)
        textField.placeholder = "010 - 1234 - 5678"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()

    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "배송지"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let addressNameTextField: ZoocTextField = {
        let textField = ZoocTextField(.numberPad)
        textField.placeholder = "우편번호"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
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
    
    private let addressTextField: ZoocTextField = {
        let textField = ZoocTextField(.default)
        textField.placeholder = "주소"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
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
        let textField = ZoocTextField(.numberPad)
        textField.placeholder = "부재 시 경비실에 맡겨주세요"
        textField.font = .zoocBody1
        textField.setPlaceholderColor(color: .zoocGray1)
        return textField
    }()
    
    private lazy var registerBasicAddressCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.checkBoxFill, for: .normal)
        button.setImage(Image.checkBox, for: .selected)
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
        setDelegate()
        setTag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        backgroundColor = .zoocBackgroundGreen
        
        detailAddressTextField.placeholder = "상세 주소"
        requestTextField.placeholder = "부재시 경비실에 맡겨주세요."
    }
    
    private func hierarchy() {
        headerView.addSubviews(titleLabel, copyButton)
        
        addSubviews(headerView, mainView)
        
        mainView.addSubviews(addressNameTextField,
                             receiverLabel,
                             receiverTextField,
                             phoneNumberLabel,
                             receiverPhoneNumberTextField,
                             addressLabel,
                             findAddressButton,
                             addressTextField,
                             detailAddressTextField,
                             registerBasicAddressCheckButton,
                             registerBasicAddressLabel,
                             requestLabel,
                             requestTextField
        )
        
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
        
        copyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
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
        
        addressNameTextField.snp.makeConstraints {
            $0.top.equalTo(receiverPhoneNumberTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(97)
            $0.trailing.equalToSuperview().inset(134)
            $0.height.equalTo(41)
        }
        
        addressLabel.snp.makeConstraints {
            $0.centerY.equalTo(addressNameTextField)
            $0.leading.equalToSuperview().inset(30)
        }
        
        findAddressButton.snp.makeConstraints {
            $0.top.height.equalTo(addressNameTextField)
            $0.leading.equalTo(addressNameTextField.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        addressTextField.snp.makeConstraints {
            $0.top.equalTo(findAddressButton.snp.bottom).offset(12)
            $0.leading.height.equalTo(addressNameTextField)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        detailAddressTextField.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(12)
            $0.leading.height.equalTo(addressNameTextField)
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
            $0.leading.trailing.height.equalTo(addressTextField)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setTag() {
        addressNameTextField.tag = 0
        receiverTextField.tag = 1
        receiverPhoneNumberTextField.tag = 2
        detailAddressTextField.tag = 3
        requestTextField.tag = 4
    }
    
    private func setDelegate() {
        addressNameTextField.zoocDelegate = self
        receiverTextField.zoocDelegate = self
        receiverPhoneNumberTextField.zoocDelegate = self
        detailAddressTextField.zoocDelegate = self
        requestTextField.zoocDelegate = self
    }
    
    //MARK: - Public Methods
    
    func updateUI(_ data: OrderAddress, isPostData: Bool = false) {
        addressNameTextField.text = data.addressName
        receiverTextField.text = data.receiverName
        receiverPhoneNumberTextField.text = data.receiverPhoneNumber
        addressNameTextField.text = data.postCode
        addressTextField.text = data.address
        detailAddressTextField.text = data.detailAddress
        
        if isPostData {
            addressLabel.textColor = .zoocGray2
            detailAddressTextField.becomeFirstResponder()
        }
        
    }
    
    func checkValidity() throws {
        addressNameTextField.updateInvalidUI()
        receiverTextField.updateInvalidUI()
        receiverPhoneNumberTextField.updateInvalidUI()
        if !(addressNameTextField.text?.hasText ?? false) {
            addressLabel.textColor = .red
        } else {
            addressLabel.textColor = .zoocGray2
        }
        
        guard addressNameTextField.hasText,
              receiverTextField.hasText,
              receiverPhoneNumberTextField.hasText else {
            throw OrderInvalidError.addressInvlid
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func copyButtonDidTap() {
        delegate?.copyButtonDidTap()
        addressNameTextField.becomeFirstResponder()
    }
    
    @objc
    private func findAddressButtonDidTap() {
        endEditing(true)
        delegate?.findAddressButtonDidTap()
    }
    
    @objc
    private func checkButtonDidTap() {
        print("기본배송지로 설정되었습니다!")
    }
}

extension OrderAddressView: ZoocTextFieldDelegate {
    
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
        delegate?.textFieldDidEndEditing(addressName: addressNameTextField.text ?? "",
                                         receiverName: receiverTextField.text ?? "",
                                         receiverPhoneNumber: receiverPhoneNumberTextField.text ?? "",
                                         detailAddress: detailAddressTextField.hasText ? detailAddressTextField.text : nil,
                                         request: detailAddressTextField.hasText ? requestTextField.text : nil)
    }
}

