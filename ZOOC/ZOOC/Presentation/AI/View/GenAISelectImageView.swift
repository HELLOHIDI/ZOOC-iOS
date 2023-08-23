//
//  GenAISelectImageView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import SnapKit
import Then

final class GenAISelectImageView: UIView {
    
    //MARK: - UI Components
    
    public lazy var xmarkButton = UIButton()
    public lazy var reSelectedImageButton = UIButton()
    public lazy var petImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let titleLabel = UILabel()
    public let subTitleLabel = UILabel()
    
    public lazy var generateAIModelButton = ZoocGradientButton()
    
    public let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func register() {
        petImageCollectionView.register(GenAIPetImageCollectionViewCell.self, forCellWithReuseIdentifier: GenAIPetImageCollectionViewCell.cellIdentifier)
    }
    
    private func style() {
        self.backgroundColor = .zoocBackgroundGreen
        
        xmarkButton.do {
            $0.setImage(Image.xmark, for: .normal)
        }
        
        titleLabel.do {
            $0.text = "아래 사진으로 확정하시나요?"
            $0.textColor = .zoocDarkGray1
            $0.font = .zoocDisplay1
            $0.textAlignment = .left
        }
        
        subTitleLabel.do {
            $0.text = "선택한 사진으로 AI 모델 생성이 진행돼요"
            $0.textColor = .zoocGray2
            $0.font = .zoocBody2
            $0.textAlignment = .center
        }
        
        petImageCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = true
        }
        
        reSelectedImageButton.do {
            $0.setTitle("사진을 다시 고를래요", for: .normal)
            $0.setTitleColor(.zoocGray1, for: .normal)
            $0.titleLabel?.font = .zoocBody2
            $0.titleLabel?.textAlignment = .center
            $0.setUnderline()
        }
        
        generateAIModelButton.do {
            $0.setTitle("AI 모델 생성하기", for: .normal)
            $0.setTitleColor(.zoocWhite1, for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.titleLabel?.textAlignment = .center
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            xmarkButton,
            titleLabel,
            subTitleLabel,
            petImageCollectionView,
            reSelectedImageButton,
            generateAIModelButton,
            activityIndicatorView
        )
    }
    
    
    private func layout() {
        xmarkButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(97)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        petImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(392)
        }
        
        reSelectedImageButton.snp.makeConstraints {
            $0.top.equalTo(self.petImageCollectionView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(23)
        }
        
        generateAIModelButton.snp.makeConstraints {
            $0.top.equalTo(self.reSelectedImageButton.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(54)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}


