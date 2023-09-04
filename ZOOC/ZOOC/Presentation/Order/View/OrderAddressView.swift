//
//  AddressView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit

protocol OrderAddressViewDelegate: AnyObject {
    func copyButtonDidTap()
}

final class OrderAddressView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAddressViewDelegate?
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    private let mainView = UIView()
    private let buttonView = UIView()
    private let basicAddressView = OrderBasicAddressView()
    let newAddressView = OrderNewAddressView()
    
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
    
    private lazy var basicAddressButton: ZoocGradientButton = {
        let button = ZoocGradientButton.init(.order)
        button.setTitle("기존 배송지", for: .normal)
        button.addTarget(self, action: #selector(basicAddressButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var newAddressButton: ZoocGradientButton = {
        let button = ZoocGradientButton.init(.order)
        button.setTitle("신규 입력", for: .normal)
        button.addTarget(self, action: #selector(newAddressButtonDidTap), for: .touchUpInside)
        return button
    }()
    
//    private let receiverLabel: UILabel = {
//        let label = UILabel()
//        label.text = "수령인"
//        label.font = .zoocBody2
//        label.textColor = .zoocGray2
//        return label
//    }()
//
//    private let receiverTextField: ZoocTextField = {
//        let textField = ZoocTextField()
//        textField.placeholder = "실명"
//        textField.font = .zoocBody1
//        textField.setPlaceholderColor(color: .zoocGray1)
//        return textField
//    }()
//
//    private let phoneNumberLabel: UILabel = {
//        let label = UILabel()
//        label.text = "연락처"
//        label.font = .zoocBody2
//        label.textColor = .zoocGray2
//        return label
//    }()
//
//    private let receiverPhoneNumberTextField: ZoocTextField = {
//        let textField = ZoocTextField(.numberPad)
//        textField.placeholder = "010 - 1234 - 5678"
//        textField.font = .zoocBody1
//        textField.setPlaceholderColor(color: .zoocGray1)
//        return textField
//    }()
//
//
//    private let addressLabel: UILabel = {
//        let label = UILabel()
//        label.text = "배송지"
//        label.font = .zoocBody2
//        label.textColor = .zoocGray2
//        return label
//    }()
//
//    private let addressNameTextField: ZoocTextField = {
//        let textField = ZoocTextField(.numberPad)
//        textField.placeholder = "우편번호"
//        textField.font = .zoocBody1
//        textField.setPlaceholderColor(color: .zoocGray1)
//        return textField
//    }()
//
//    private lazy var findAddressButton: ZoocGradientButton = {
//        let button = ZoocGradientButton.init(.order)
//        button.setTitle("주소 검색", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)!
//        button.addTarget(self,
//                         action: #selector(findAddressButtonDidTap),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    private let addressTextField: ZoocTextField = {
//        let textField = ZoocTextField(.default)
//        textField.placeholder = "주소"
//        textField.font = .zoocBody1
//        textField.setPlaceholderColor(color: .zoocGray1)
//        return textField
//    }()
//
//    private let detailAddressTextField: ZoocTextField = {
//        let textField = ZoocTextField(.default)
//        textField.placeholder = "상세주소"
//        textField.font = .zoocBody1
//        textField.setPlaceholderColor(color: .zoocGray1)
//        return textField
//    }()
//
//
//    private let requestLabel: UILabel = {
//        let label = UILabel()
//        label.text = "요청사항"
//        label.font = .zoocBody2
//        label.textColor = .zoocGray2
//        return label
//    }()
//
//    private let requestTextField: ZoocTextField = {
//        let textField = ZoocTextField(.numberPad)
//        textField.placeholder = "부재 시 경비실에 맡겨주세요"
//        textField.font = .zoocBody1
//        textField.setPlaceholderColor(color: .zoocGray1)
//        return textField
//    }()
//
//    private lazy var registerBasicAddressCheckButton: UIButton = {
//        let button = UIButton()
//        button.setImage(Image.checkBoxFill, for: .normal)
//        button.setImage(Image.checkBox, for: .selected)
//        button.setImage(Image.checkBoxRed, for: .highlighted)
//        button.addTarget(self,
//                         action: #selector(checkButtonDidTap),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    private let registerBasicAddressLabel: UILabel = {
//        let label = UILabel()
//        label.text = "기존 배송지로 등록"
//        label.font = .zoocBody1
//        label.textAlignment = .left
//        label.textColor = .zoocGray2
//        return label
//    }()
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
//        setDelegate()
//        setTag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        headerView.addSubviews(titleLabel, copyButton)
        
        addSubviews(headerView, mainView)
        
        mainView.addSubviews(buttonView,
                             basicAddressView,
                             newAddressView)
        
        buttonView.addSubviews(basicAddressButton, newAddressButton)
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
        
        buttonView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        basicAddressButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(152)
            $0.height.equalTo(54)
        }
        
        newAddressButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.width.equalTo(152)
            $0.height.equalTo(54)
        }
        
        basicAddressView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        newAddressView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
//        receiverTextField.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().inset(97)
//            $0.trailing.equalToSuperview().inset(30)
//            $0.height.equalTo(40)
//        }
//
//        receiverLabel.snp.makeConstraints {
//            $0.centerY.equalTo(receiverTextField)
//            $0.leading.equalToSuperview().inset(30)
//        }
//
//        receiverPhoneNumberTextField.snp.makeConstraints {
//            $0.top.equalTo(receiverTextField.snp.bottom).offset(12)
//            $0.leading.trailing.height.equalTo(receiverTextField)
//        }
//
//        phoneNumberLabel.snp.makeConstraints {
//            $0.centerY.equalTo(receiverPhoneNumberTextField)
//            $0.leading.equalToSuperview().inset(30)
//        }
//
//        addressNameTextField.snp.makeConstraints {
//            $0.top.equalTo(receiverPhoneNumberTextField.snp.bottom).offset(10)
//            $0.leading.equalToSuperview().offset(97)
//            $0.trailing.equalToSuperview().inset(134)
//            $0.height.equalTo(41)
//        }
//
//        addressLabel.snp.makeConstraints {
//            $0.centerY.equalTo(addressNameTextField)
//            $0.leading.equalToSuperview().inset(30)
//        }
//
//        findAddressButton.snp.makeConstraints {
//            $0.top.height.equalTo(addressNameTextField)
//            $0.leading.equalTo(addressNameTextField.snp.trailing).offset(12)
//            $0.trailing.equalToSuperview().inset(30)
//        }
//
//        addressTextField.snp.makeConstraints {
//            $0.top.equalTo(findAddressButton.snp.bottom).offset(12)
//            $0.leading.height.equalTo(addressNameTextField)
//            $0.trailing.equalToSuperview().inset(30)
//        }
//
//        detailAddressTextField.snp.makeConstraints {
//            $0.top.equalTo(addressTextField.snp.bottom).offset(12)
//            $0.leading.height.equalTo(addressNameTextField)
//            $0.trailing.equalToSuperview().inset(30)
//        }
//
//        registerBasicAddressCheckButton.snp.makeConstraints {
//            $0.top.equalTo(detailAddressTextField.snp.bottom).offset(13)
//            $0.leading.equalToSuperview().offset(97)
//            $0.size.equalTo(20)
//        }
//
//        registerBasicAddressLabel.snp.makeConstraints {
//            $0.centerY.equalTo(registerBasicAddressCheckButton)
//            $0.leading.equalTo(registerBasicAddressCheckButton.snp.trailing).offset(10)
//        }
//
//        requestLabel.snp.makeConstraints {
//            $0.centerY.equalTo(requestTextField)
//            $0.leading.equalToSuperview().inset(30)
//        }
//
//        requestTextField.snp.makeConstraints {
//            $0.top.equalTo(registerBasicAddressCheckButton.snp.bottom).offset(12)
//            $0.leading.trailing.height.equalTo(addressTextField)
//            $0.bottom.equalToSuperview().inset(20)
//        }
    }
    
    //MARK: - Public Methods
    
    func updateUI(_ data: OrderAddress, isPostData: Bool = false) {
        newAddressView.updateUI(data)
        
    }
    
    func checkValidity() throws {
        try newAddressView.checkValidity()
    }
    
    //MARK: - Action Method
    
    @objc
    private func copyButtonDidTap() {
        delegate?.copyButtonDidTap()
//        newAddressView.addressNameTextField.becomeFirstResponder()
    }
    
    @objc
    private func basicAddressButtonDidTap() {
        copyButton.isHidden = true
        basicAddressView.isHidden = false
        newAddressView.isHidden = true
    }
    
    @objc
    private func newAddressButtonDidTap() {
        copyButton.isHidden = false
        basicAddressView.isHidden = true
        newAddressView.isHidden = false
    }
}

