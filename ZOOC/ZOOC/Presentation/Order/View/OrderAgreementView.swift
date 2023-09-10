//
//  OrderAgreementView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/25.
//

import UIKit

import SnapKit

protocol OrderAgreementViewDelegate: AnyObject {
    func allPoliciesAgreemCheckButtonDidChange(allPoliciesAgree: Bool)
    func checkButtonDidChange(onwardTransfer: Bool, termOfUse: Bool)
    func watchButtonDidTap(_ type: OrderAgreementView.Policy)
}

final class OrderAgreementView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAgreementViewDelegate?
    
    enum Policy {
        case onwardTransfer
        case privacyPolicy
    }
    
    //MARK: - UI Components
    
    private lazy var allPoliciesAgreemCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.checkBox, for: .normal)
        button.setImage(Image.checkBoxFill, for: .selected)
        button.setImage(Image.checkBoxRed, for: .highlighted)
        button.addTarget(self,
                         action: #selector(allPoliciesAgreemCheckButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let allPoliciesAgreemLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 내용을 확인했으며, 모두 동의합니다."
        label.font = .zoocBody2
        label.textColor = .zoocGray3
        return label
    }()
    
    private lazy var privacyPolicyCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.checkBox, for: .normal)
        button.setImage(Image.checkBoxFill, for: .selected)
        button.setImage(Image.checkBoxRed, for: .highlighted)
        button.addTarget(self,
                         action: #selector(checkButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.text = "(필수) 개인정보 이용약관 동의"
        label.font = .zoocBody2
        label.textColor = .zoocGray1
        return label
    }()
    
    private lazy var watchPrivacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.next, for: .normal)
        button.addTarget(self,
                         action: #selector(watchButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var onwardTransferCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.checkBox, for: .normal)
        button.setImage(Image.checkBoxFill, for: .selected)
        button.setImage(Image.checkBoxRed, for: .highlighted)
        button.addTarget(self,
                         action: #selector(checkButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let onwardTransferLabel: UILabel = {
        let label = UILabel()
        label.text = "(필수) 제 3자 정보제공 동의 "
        label.font = .zoocBody2
        label.textColor = .zoocGray1
        return label
    }()
    
    private lazy var watchOnwardTransferButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.next, for: .normal)
        button.addTarget(self,
                         action: #selector(watchButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        backgroundColor = .zoocBackgroundGreen
    }
    
    private func hierarchy() {
        addSubviews(allPoliciesAgreemCheckButton,
                    allPoliciesAgreemLabel,
                    onwardTransferCheckButton,
                    onwardTransferLabel,
                    watchOnwardTransferButton,
                    privacyPolicyCheckButton,
                    privacyPolicyLabel,
                    watchPrivacyPolicyButton)
    }
    
    private func layout() {
        allPoliciesAgreemCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
        }
        
        allPoliciesAgreemLabel.snp.makeConstraints {
            $0.centerY.equalTo(allPoliciesAgreemCheckButton)
            $0.leading.equalTo(allPoliciesAgreemCheckButton.snp.trailing)
        }
        
        privacyPolicyCheckButton.snp.makeConstraints {
            $0.top.equalTo(allPoliciesAgreemCheckButton.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
        }
        
        privacyPolicyLabel.snp.makeConstraints {
            $0.centerY.equalTo(privacyPolicyCheckButton)
            $0.leading.equalTo(privacyPolicyCheckButton.snp.trailing)
        }
        
        watchPrivacyPolicyButton.snp.makeConstraints {
            $0.centerY.equalTo(privacyPolicyCheckButton)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        
        onwardTransferCheckButton.snp.makeConstraints {
            $0.top.equalTo(privacyPolicyCheckButton.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        onwardTransferLabel.snp.makeConstraints {
            $0.centerY.equalTo(onwardTransferCheckButton)
            $0.leading.equalTo(onwardTransferCheckButton.snp.trailing)
        }
        
        watchOnwardTransferButton.snp.makeConstraints {
            $0.centerY.equalTo(onwardTransferCheckButton)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
    }
    
    func updateUI(_ data: OrderAgreement) {
        onwardTransferCheckButton.isSelected = data.agreeWithOnwardTransfer
        privacyPolicyCheckButton.isSelected = data.agreeWithTermOfUse
        allPoliciesAgreemCheckButton.isSelected = data.agreeWithOnwardTransfer && data.agreeWithTermOfUse
    }
    
    //MARK: - Public Methods
    
    func checkValidity() throws {
        onwardTransferCheckButton.isHighlighted = !onwardTransferCheckButton.isSelected
        privacyPolicyCheckButton.isHighlighted = !privacyPolicyCheckButton.isSelected
        
        guard onwardTransferCheckButton.isSelected,
              privacyPolicyCheckButton.isSelected else {
            throw OrderInvalidError.agreementInvalid
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func allPoliciesAgreemCheckButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.allPoliciesAgreemCheckButtonDidChange(allPoliciesAgree: allPoliciesAgreemCheckButton.isSelected)
    }
    
    
    @objc
    private func checkButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.checkButtonDidChange(
            onwardTransfer: onwardTransferCheckButton.isSelected,
            termOfUse: privacyPolicyCheckButton.isSelected
        )
    }
    
    @objc
    private func watchButtonDidTap(_ sender: UIButton) {
        
        var type: Policy
        
        switch sender {
        case watchOnwardTransferButton:
            type = .onwardTransfer
        case watchPrivacyPolicyButton:
            type = .privacyPolicy
        default:
            return
        }
        
        delegate?.watchButtonDidTap(type)
    }
    
}


