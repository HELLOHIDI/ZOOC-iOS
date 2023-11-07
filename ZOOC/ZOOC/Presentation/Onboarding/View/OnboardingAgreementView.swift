//
//  OnboardingAgreementView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

final class OnboardingAgreementView: UIView {

    //MARK: - UI Components
    
    let backButton = UIButton()
    private let agreeTitleLabel = UILabel()
    public lazy var agreementCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    public lazy var signUpButton = ZoocGradientButton()
    
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
        agreementCollectionView.register(
            OnboardingAgreementCollectionViewCell.self,
            forCellWithReuseIdentifier: OnboardingAgreementCollectionViewCell.cellIdentifier)
        
        agreementCollectionView.register(
            OnboardingAgreementCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: OnboardingAgreementCollectionHeaderView.reuseCellIdentifier)
    }
    
    private func style() {
        self.backgroundColor = .zoocBackgroundGreen
        
        agreeTitleLabel.do {
            $0.text = "더 나은 서비스 제공을 위해 \n약관동의가 필요해요"
            $0.textColor = .zoocDarkGray2
            $0.textAlignment = .left
            $0.font = .zoocDisplay1
            $0.numberOfLines = 2
            $0.setLineSpacing(spacing: 6)
        }
        
        agreementCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 315, height: 22)
            layout.minimumLineSpacing = 15
            layout.headerReferenceSize = CGSize(width: 315, height: 80)
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        signUpButton.do {
            $0.setTitle("회원가입", for: .normal)
        }
    }
    private func hierarchy() {
        self.addSubviews(
            agreeTitleLabel,
            agreementCollectionView,
            signUpButton
        )
    }
    
    private func layout() {
        agreeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(77)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(68)
        }
        
        agreementCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.agreeTitleLabel.snp.bottom).offset(43)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.bottom.equalTo(signUpButton.snp.top)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(54)
        }
    }
}
