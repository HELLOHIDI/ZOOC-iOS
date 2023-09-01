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
        label.text = "배송지"
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("위와 동일하게 채우기", for: .normal)
        button.setTitleColor(.zoocMainGreen, for: .normal)
        button.titleLabel?.font = .zoocSubhead1
        button.addTarget(self,
                         action: #selector(copyButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let addressNameLabel: UILabel = {
        let label = UILabel()
        label.text = "배송지명"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let addressNameTextField = ZoocTextField()
    
    private let receiverLabel: UILabel = {
        let label = UILabel()
        label.text = "받는 사람"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let receiverTextField = ZoocTextField()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let receiverPhoneNumberTextField = ZoocTextField(.numberPad)
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "주소"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private lazy var findAddressButton: UIButton = {
        let button = UIButton()
        button.setBorder(borderWidth: 1, borderColor: .zoocMainGreen)
        button.makeCornerRound(radius: 7)
        button.setTitle("주소 찾기", for: .normal)
        button.setTitleColor(.zoocMainGreen, for: .normal)
        button.titleLabel?.font = .zoocBody3
        button.backgroundColor = .zoocWhite1
        button.addTarget(self,
                         action: #selector(findAddressButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let postCodeLabelBox: BasePaddingLabel = {
        let label = BasePaddingLabel(leftPadding: 10)
        label.backgroundColor = .zoocLightGray
        label.setBorder(borderWidth: 1, borderColor: .zoocLightGray)
        label.makeCornerRound(radius: 7)
        return label
    }()
    
    private let addressLabelBox: BasePaddingLabel = {
        let label = BasePaddingLabel(leftPadding: 10)
        label.backgroundColor = .zoocLightGray
        label.setBorder(borderWidth: 1, borderColor: .zoocLightGray)
        label.makeCornerRound(radius: 7)
        label.numberOfLines = 0
        return label
    }()
    
    private let detailAddressTextField = ZoocTextField()
    
    private let requestLabel: UILabel = {
        let label = UILabel()
        label.text = "요청사항"
        label.font = .zoocBody2
        label.textColor = .zoocGray2
        return label
    }()
    
    private let requestTextField = ZoocTextField()
    
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
        
        mainView.addSubviews(addressNameLabel,
                             addressNameTextField,
                             receiverLabel,
                             receiverTextField,
                             phoneNumberLabel,
                             receiverPhoneNumberTextField,
                             addressLabel,
                             findAddressButton,
                             postCodeLabelBox,
                             addressLabelBox,
                             detailAddressTextField,
                             requestLabel,
                             requestTextField)
        
    }
    
    private func layout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        copyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addressNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(100)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        addressNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(addressNameTextField)
            $0.leading.equalToSuperview().inset(20)
        }
        
        receiverTextField.snp.makeConstraints {
            $0.top.equalTo(addressNameTextField.snp.bottom).offset(10)
            $0.leading.trailing.height.equalTo(addressNameTextField)
            
        }
        
        receiverLabel.snp.makeConstraints {
            $0.centerY.equalTo(receiverTextField)
            $0.leading.equalToSuperview().inset(20)
        }
        
        receiverPhoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(receiverTextField.snp.bottom).offset(10)
            $0.leading.trailing.height.equalTo(addressNameTextField)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(receiverPhoneNumberTextField)
            $0.leading.equalToSuperview().inset(20)
        }
        
        findAddressButton.snp.makeConstraints {
            $0.top.equalTo(receiverPhoneNumberTextField.snp.bottom).offset(10)
            $0.leading.equalTo(receiverPhoneNumberTextField)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
        
        addressLabel.snp.makeConstraints {
            $0.centerY.equalTo(findAddressButton)
            $0.leading.equalToSuperview().inset(20)
        }
        
        postCodeLabelBox.snp.makeConstraints {
            $0.top.equalTo(findAddressButton)
            $0.leading.equalTo(findAddressButton.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
        
        addressLabelBox.snp.makeConstraints {
            $0.top.equalTo(findAddressButton.snp.bottom).offset(7)
            $0.leading.equalTo(findAddressButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        detailAddressTextField.snp.makeConstraints {
            $0.top.equalTo(addressLabelBox.snp.bottom).offset(7)
            $0.leading.trailing.height.equalTo(addressLabelBox)
        }
        
        requestLabel.snp.makeConstraints {
            $0.centerY.equalTo(requestTextField)
            $0.leading.equalToSuperview().inset(20)
        }
        
        requestTextField.snp.makeConstraints {
            $0.top.equalTo(detailAddressTextField.snp.bottom).offset(7)
            $0.leading.trailing.height.equalTo(addressLabelBox)
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
        postCodeLabelBox.text = data.postCode
        addressLabelBox.text = data.address
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
        
        if !(postCodeLabelBox.text?.hasText ?? false) {
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

