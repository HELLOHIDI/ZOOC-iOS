//
//  OrderAgreementView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/25.
//

import UIKit

import SnapKit

protocol OrderAgreementViewDelegate: AnyObject {
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
        label.text = "(필수) 개인정보 이용약관 동의"
        label.font = .zoocBody2
        label.textColor = .zoocGray3
        label.asColor(targetString: "(필수)", color: .zoocGray1)
        return label
    }()
    
    private lazy var watchOnwardTransferButton: UIButton = {
        let button = UIButton()
        button.setTitle("약관 보기", for: .normal)
        button.titleLabel?.asUnderLine("약관 보기")
        button.setTitleColor(.zoocGray1, for: .normal)
        button.titleLabel?.font = .zoocBody1
        button.addTarget(self,
                         action: #selector(watchButtonDidTap),
                         for: .touchUpInside)
        return button
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
        label.text = "(선택) 마케팅 정보 수신 동의"
        label.font = .zoocBody2
        label.textColor = .zoocGray3
        label.asColor(targetString: "(선택)", color: .zoocGray1)
        return label
    }()
    
    private lazy var watchPrivacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("약관 보기", for: .normal)
        button.titleLabel?.asUnderLine("약관 보기")
        button.setTitleColor(.zoocGray1, for: .normal)
        button.titleLabel?.font = .zoocBody1
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
        addSubviews(onwardTransferCheckButton,
                    onwardTransferLabel,
                    watchOnwardTransferButton,
                    privacyPolicyCheckButton,
                    privacyPolicyLabel,
                    watchPrivacyPolicyButton)
    }
    
    private func layout() {
        
        onwardTransferCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
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
        
        privacyPolicyCheckButton.snp.makeConstraints {
            $0.top.equalTo(onwardTransferCheckButton.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
            $0.bottom.equalToSuperview().inset(20)
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
    private func checkButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.checkButtonDidChange(onwardTransfer: onwardTransferCheckButton.isSelected,
                                       termOfUse: privacyPolicyCheckButton.isSelected)
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


