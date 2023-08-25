//
//  OrderAgreementView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/25.
//

import UIKit

import SnapKit

final class OrderAgreementView: UIView {
    
    //MARK: - Properties
    
    
    //MARK: - UI Components
    
    private let onwardTransferCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.checkBox, for: .normal)
        button.setImage(Image.checkBoxFill, for: .selected)
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
        button.titleLabel?.asUnderLine($0.text)
        button.setTitleColor(.zoocGray2, for: .normal)
        button.font = .zoocBody1
        return button
    }()
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        register()
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
                    watchOnwardTransferButton)
    }
    
    private func layout() {
        
        onwardTransferCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(30)
            $0.size.equalTo(42)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        onwardTransferLabel.snp.makeConstraints {
            $0.centerY.equalTo(onwardTransferCheckButton)
            $0.leading.equalTo(onwardTransferCheckButton).offset(20)
        }
        
        watchOnwardTransferButton.snp.makeConstraints {
            $0.centerY.equalTo(onwardTransferCheckButton)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        
        
        
    }
    
    private func register() {
    }
    
    //MARK: - Action Method
    
    
    
}


