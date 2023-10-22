//
//  ShopLoadingView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/21.
//

import UIKit

import SnapKit
import Then

final class ShopLoadingView: UIView {
    
    // MARK: - Properties
    
    public let titleLabel = UILabel()
    public let subTitleLabel = UILabel()
    public let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func style() {
        titleLabel.do {
            $0.text = "AI 모델을 생성 중이에요"
            $0.textColor = .zoocGray3
            $0.textAlignment = .center
            $0.font = .zoocDisplay1
        }
        
        subTitleLabel.do {
            $0.text = "최대 1-2분 가량 소요될 수 있어요\n안정적인 모델 생성을 위해 화면에 머물러 주세요"
            $0.numberOfLines = 2
            $0.font = .zoocBody3
            $0.textColor = .zoocGray1
            $0.setLineSpacing(spacing: 8)
            $0.textAlignment = .center
        }
    }
    
    private func hieararchy() {
        self.addSubviews(titleLabel, subTitleLabel, activityIndicatorView)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(192)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(79)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(185)
        }
    }
}






