//
//  RecordMissionView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/05/11.
//

import UIKit

import SnapKit
import Then

final class RecordMissionView : UIView {
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let topBarView = UIView()
    public lazy var xmarkButton = UIButton()
    private let buttonsContainerView = UIView()
    public lazy var dailyButton = UIButton()
    private lazy var missionButton = UIButton()
    public var missionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    public lazy var nextButton = UIButton()
    
    //MARK: - Life Cycle
    
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
        missionCollectionView.register(RecordMissionCollectionViewCell.self, forCellWithReuseIdentifier: RecordMissionCollectionViewCell.cellIdentifier)
    }
    
    private func style() {
        xmarkButton.do {
            $0.setImage(Image.xmark, for: .normal)
        }
        
        dailyButton.do {
            $0.setTitle("일상", for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.setTitleColor(.zoocGray1, for: .normal)
        }
        
        missionButton.do {
            $0.setTitle("미션", for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.setTitleColor(.zoocDarkGray1, for: .normal)
        }
        
        missionCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.decelerationRate = .fast
            $0.isPagingEnabled = false
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .zoocSubhead2
            $0.setTitleColor(.zoocWhite1, for: .normal)
            $0.backgroundColor = .zoocGray1
            $0.isEnabled = false
            $0.layer.cornerRadius = 27
        }
    }
    
    private func hierarchy() {
        self.addSubviews(topBarView,  nextButton, missionCollectionView)
        topBarView.addSubviews(xmarkButton, buttonsContainerView)
        buttonsContainerView.addSubviews(dailyButton, missionButton)
    }
    
    private func layout() {
        topBarView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(42)
        }
        
        xmarkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.width.equalTo(42)
            $0.height.equalTo(42)
        }
        
        buttonsContainerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(22)
            $0.width.equalTo(112)
            $0.height.equalTo(42)
        }
        
        dailyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(self.missionButton.snp.leading)
            $0.width.equalTo(56)
            $0.height.equalTo(42)
        }
        
        missionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(42)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        missionCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.topBarView.snp.bottom).offset(55)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.58)
        }
    }
}
