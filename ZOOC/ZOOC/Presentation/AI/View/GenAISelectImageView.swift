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
    
    public lazy var backButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }
        
        scrollView.do {
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
        }
        
        titleLabel.do {
            $0.text = "선택한 사진으로 확정하시나요?"
            $0.textColor = .zoocMainGreen
            $0.font = .zoocDisplay1
            $0.textAlignment = .left
            $0.asColor(targetString: "선택한 사진", color: .zoocMainGreen)
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
            $0.isScrollEnabled = false
        }
        
        generateAIModelButton.do {
            $0.setTitle("AI 모델 생성하기", for: .normal)
            $0.setTitleColor(.zoocWhite1, for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.titleLabel?.textAlignment = .center
        }
    }
    
    private func hierarchy() {
        self.addSubviews(backButton, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            titleLabel,
            subTitleLabel,
            petImageCollectionView,
            generateAIModelButton,
            activityIndicatorView
        )
    }
        
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.backButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(4)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        petImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(84)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(2000)
        }
        
        generateAIModelButton.snp.makeConstraints {
            $0.top.equalTo(self.petImageCollectionView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(54)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
    
    
