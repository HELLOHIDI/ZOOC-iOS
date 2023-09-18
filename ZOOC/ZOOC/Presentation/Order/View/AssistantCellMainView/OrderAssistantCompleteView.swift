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
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: Image.checkCircleBig)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var completeButton: ZoocGradientButton = {
        let button = ZoocGradientButton(.medium)
        button.setTitle("네, 확인했어요", for: .normal)
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
                    imageView,
                    completeButton)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(18)
        }
    }

    
    //MARK: - Action Method

    @objc
    private func completeButtonDidTap() {
        delegate?.completeButtonDidTap()
    }
    
    
    
}

