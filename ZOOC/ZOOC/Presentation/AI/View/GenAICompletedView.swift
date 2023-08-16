//
//  GenAICompletedView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/16.
//

import UIKit

import SnapKit
import Then

final class GenAICompletedView: UIView {
    
    // MARK: - Properties
    
    public var cancelButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let notifyImageView = UIImageView()
    public var goShopButton = ZoocGradientButton()
    
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
        self.backgroundColor = .zoocBackgroundGreen
        
        cancelButton.do{
            $0.setImage(Image.xmark, for: .normal)
        }
        
        titleLabel.do{
            $0.text = "AI 모델을 생성하고 있어요 "
            $0.font = .zoocDisplay1
            $0.textColor = .zoocDarkGray1
            $0.asColor(targetString: "AI 모델", color: .zoocMainGreen)
        }
        
        subTitleLabel.do{
            $0.text = "앞으로 만들 수 있는 굿즈를 둘러보세요"
            $0.font = .zoocBody2
            $0.textColor = .zoocGray2
        }
        
        notifyImageView.do{
            $0.image = Image.graphics13
        }
        
        goShopButton.do{
            $0.setTitle("쇼핑몰 둘러보기", for: .normal)
            $0.setTitleColor(.zoocWhite1, for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.titleLabel?.textAlignment = .center
        }
    }
    
    private func hieararchy() {
        self.addSubviews(cancelButton, titleLabel, subTitleLabel, notifyImageView, goShopButton)
    }
    
    private func layout() {
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(121)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        notifyImageView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(85)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(267)
        }
        
        goShopButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(14)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
    }
}





