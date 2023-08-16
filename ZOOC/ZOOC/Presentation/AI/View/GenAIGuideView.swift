//
//  GenAIView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

final class GenAIGuideView: UIView {
    
    //MARK: - UI Components
    
    public lazy var backButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let featuredView = UIView()
    private let featuredImageView = UIImageView()
    private let featuredDescribeLabel = UILabel()
    private let featuredSubDescribeLabel = UILabel()
    
    private let deprecatedView = UIView()
    private let deprecatedImageView1 = UIImageView()
    private let deprecatedCaption1 = UILabel()
    private let deprecatedImageView2 = UIImageView()
    private let deprecatedCaption2 = UILabel()
    private let deprecatedImageView3 = UIImageView()
    private let deprecatedCaption3 = UILabel()
    private let deprecatedDescribeLabel = UILabel()
    
    public lazy var selectImageButton = ZoocGradientButton()
    
    //MARK: - Life Cycles
    
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
        self.backgroundColor = .zoocBackgroundGreen
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }
        
        titleLabel.do {
            $0.text = "사진을 선택해주세요"
            $0.textColor = .zoocMainGreen
            $0.font = .zoocDisplay1
            $0.textAlignment = .left
        }
        
        subTitleLabel.do {
            $0.text = "최적의 학습을 위해 아래 기준을 추천드려요"
            $0.textColor = .zoocGray2
            $0.font = .zoocBody2
            $0.textAlignment = .center
        }
        
        featuredView.do {
            $0.backgroundColor = .zoocWhite2
            $0.makeCornerBorder(borderWidth: 1, borderColor: .zoocLightGreen)
            $0.makeCornerRound(radius: 20)
        }
        
        featuredImageView.do {
            $0.image = Image.mockfeaturedImage
        }
        
        featuredDescribeLabel.do {
            $0.text = "비슷한 자세의 정면사진들이 가장 좋아요"
            $0.font = .zoocBody1
            $0.textAlignment = .left
            $0.textColor = UIColor(r: 104, g: 104, b: 85)
            $0.asColor(targetString: "정면사진들", color: .zoocMainGreen)
        }
        
        featuredSubDescribeLabel.do {
            $0.text = "최대한 발이 잘리지 않게 찍어주세요!"
            $0.font = .zoocCaption
            $0.textAlignment = .left
            $0.textColor = UIColor(r: 104, g: 104, b: 85)
        }
        
        deprecatedView.do {
            $0.backgroundColor = .zoocWhite2
            $0.makeCornerBorder(borderWidth: 1, borderColor: .zoocLightGreen)
            $0.makeCornerRound(radius: 20)
        }
        
        deprecatedImageView1.do {
            $0.image = Image.mockdeprecated1
        }
        
        deprecatedCaption1.do {
            $0.text = "입을 벌림"
            $0.textColor = UIColor(r: 104, g: 104, b: 85)
            $0.font = .zoocCaption
        }
        
        deprecatedImageView2.do {
            $0.image = Image.mockdeprecated2
        }
        
        deprecatedCaption2.do {
            $0.text = "신체 부위 잘림"
            $0.textColor = UIColor(r: 104, g: 104, b: 85)
            $0.font = .zoocCaption
        }
        
        deprecatedImageView3.do {
            $0.image = Image.mockdeprecated3
        }
        
        deprecatedCaption3.do {
            $0.text = "화질이 나쁨"
            $0.textColor = UIColor(r: 104, g: 104, b: 85)
            $0.font = .zoocCaption
        }
        
        deprecatedDescribeLabel.do {
            $0.text = "옷 입은 사진도 AI 인식이 힘들어요"
            $0.textColor = UIColor(r: 104, g: 104, b: 85)
            $0.font = .zoocBody1
            $0.asColor(targetString: "옷 입은 사진", color: UIColor(r: 255, g: 83, b: 83))
        }
        
        selectImageButton.do {
            $0.setTitle("사진 선택하기", for: .normal)
            $0.setTitleColor(.zoocWhite1, for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.titleLabel?.textAlignment = .center
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            backButton,
            titleLabel,
            subTitleLabel,
            featuredView,
            deprecatedView,
            selectImageButton
        )
        
        featuredView.addSubviews(
            featuredImageView,
            featuredDescribeLabel,
            featuredSubDescribeLabel
        )
        
        deprecatedView.addSubviews(
            deprecatedImageView1,
            deprecatedCaption1,
            deprecatedImageView2,
            deprecatedCaption2,
            deprecatedImageView3,
            deprecatedCaption3,
            deprecatedDescribeLabel
        )
    }
        
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(84)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        featuredView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(194)
        }
        
        deprecatedView.snp.makeConstraints {
            $0.top.equalTo(self.featuredView.snp.bottom).offset(29)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(194)
        }
        
        selectImageButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(54)
        }
        
        //Featured View
        
        featuredImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(11)
            $0.height.equalTo(89)
        }
        
        featuredDescribeLabel.snp.makeConstraints {
            $0.top.equalTo(self.featuredImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        featuredSubDescribeLabel.snp.makeConstraints {
            $0.top.equalTo(self.featuredDescribeLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        //DeprecatedView View
        
        deprecatedImageView1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(11)
            $0.size.equalTo(89)
        }
        
        deprecatedCaption1.snp.makeConstraints {
            $0.top.equalTo(self.deprecatedImageView1.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(33)
        }
        
        deprecatedImageView2.snp.makeConstraints {
            $0.top.equalTo(self.deprecatedImageView1)
            $0.leading.equalTo(self.deprecatedImageView1.snp.trailing).offset(13)
            $0.size.equalTo(89)
        }
        
        deprecatedCaption2.snp.makeConstraints {
            $0.top.equalTo(self.deprecatedImageView1.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        deprecatedImageView3.snp.makeConstraints {
            $0.top.equalTo(self.deprecatedImageView1)
            $0.leading.equalTo(self.deprecatedImageView2.snp.trailing).offset(13)
            $0.size.equalTo(89)
        }
        
        deprecatedCaption3.snp.makeConstraints {
            $0.top.equalTo(self.deprecatedImageView1.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        deprecatedDescribeLabel.snp.makeConstraints {
            $0.top.equalTo(self.deprecatedCaption2.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
    
    
