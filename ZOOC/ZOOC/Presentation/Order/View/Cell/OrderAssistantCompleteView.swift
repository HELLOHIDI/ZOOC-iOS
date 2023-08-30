//
//  OrderCompleteStepView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/31.
//

import UIKit

import SnapKit

protocol OrderAssistantCompleteViewDelegate: AnyObject {
    func completeButtonDidTap()
}

final class OrderAssistantCompleteView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAssistantCompleteViewDelegate?
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주문해주셔서 감사합니다.\n주문 확인시 카카오톡 채널톡 \n알림을 보내드립니다."
        label.font = .zoocBody3
        label.textColor = .zoocDarkGray1
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var completeButton: ZoocGradientButton = {
        let button = ZoocGradientButton(.medium)
        button.setTitle("네, 알겠습니다", for: .normal)
        button.addTarget(self,
                         action: #selector(completeButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI & Layout
    
    private func style() {
        backgroundColor = .zoocWhite1
    }
    
    private func hierarchy() {
        addSubviews(titleLabel,
                    completeButton)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
            
        completeButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(47)
            
        }
    }

    
    //MARK: - Action Method

    @objc
    private func completeButtonDidTap() {
        delegate?.completeButtonDidTap()
    }
    
    
    
}

