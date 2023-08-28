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
}

final class OrderAgreementView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAgreementViewDelegate?
    
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
        label.text = "개인정보 제 3자 제공 동의 (필수)"
        label.font = .zoocBody2
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let watchOnwardTransferButton: UIButton = {
        let button = UIButton()
        button.setTitle("약관 보기", for: .normal)
        button.titleLabel?.asUnderLine("약관 보기")
        button.setTitleColor(.zoocGray1, for: .normal)
        button.titleLabel?.font = .zoocBody1
        return button
    }()
    
    private lazy var termOfUseCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.checkBox, for: .normal)
        button.setImage(Image.checkBoxFill, for: .selected)
        button.setImage(Image.checkBoxRed, for: .highlighted)
        button.addTarget(self,
                         action: #selector(checkButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let termOfUseLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 수집 및 이용 (필수)"
        label.font = .zoocBody2
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let watchTermOfUseButton: UIButton = {
        let button = UIButton()
        button.setTitle("약관 보기", for: .normal)
        button.titleLabel?.asUnderLine("약관 보기")
        button.setTitleColor(.zoocGray1, for: .normal)
        button.titleLabel?.font = .zoocBody1
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
                    termOfUseCheckButton,
                    termOfUseLabel,
                    watchTermOfUseButton)
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
        
        termOfUseCheckButton.snp.makeConstraints {
            $0.top.equalTo(onwardTransferCheckButton.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        termOfUseLabel.snp.makeConstraints {
            $0.centerY.equalTo(termOfUseCheckButton)
            $0.leading.equalTo(termOfUseCheckButton.snp.trailing)
        }
        
        watchTermOfUseButton.snp.makeConstraints {
            $0.centerY.equalTo(termOfUseCheckButton)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        
        
        
        
    }
    
    //MARK: - Public Methods
    
    func checkValidity() throws {
        onwardTransferCheckButton.isHighlighted = !onwardTransferCheckButton.isSelected
        termOfUseCheckButton.isHighlighted = !termOfUseCheckButton.isSelected
        
        guard onwardTransferCheckButton.isSelected,
              termOfUseCheckButton.isSelected else {
            throw OrderInvalidError.agreementInvalid
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func checkButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.checkButtonDidChange(onwardTransfer: onwardTransferCheckButton.isSelected,
                                       termOfUse: termOfUseCheckButton.isSelected)
    }
    
}


