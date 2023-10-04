//
//  RecordRegistgerView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/05/12.
//

import UIKit

import SnapKit
import Then

final class RecordSelectPetView : UIView{
    
    // MARK: - Properties
    
    var petList: [RecordRegisterModel] = []
    var selectedPetIDList: [Int] = []
    
    // MARK: - UI Components
    
    private let topBarView = UIView()
    public lazy var xmarkButton = UIButton()
    private let cardView = UIView()
    private let headerView = UIView()
    public lazy var backButton = UIButton()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    public lazy var petCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    public lazy var registerButton = ZoocGradientButton.init(.network)
    
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
        petCollectionView.register(RecordRegisterCollectionViewCell.self,
                                   forCellWithReuseIdentifier: RecordRegisterCollectionViewCell.cellIdentifier)
        
        petCollectionView.register(RecordRegisterFourCollectionViewCell.self,
                                   forCellWithReuseIdentifier: RecordRegisterFourCollectionViewCell.cellIdentifier)
    }
    
    private func style() {
        xmarkButton.do {
            $0.setImage(Image.xmark, for: .normal)
        }
        
        cardView.do {
            $0.layer.cornerRadius = 24
            $0.layer.shadowColor = UIColor.zoocSubGreen.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 14
            $0.clipsToBounds = true
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.backgroundColor = .white
        }
        
        backButton.do {
            $0.setImage(Image.backCircle, for: .normal)
        }
        
        titleLabel.do {
            $0.text = "반려동물 선택"
            $0.font = .zoocSubhead2
            $0.textColor = .zoocDarkGray1
        }
        
        subtitleLabel.do {
            $0.text = "어디에 기록을 남길까요?"
            $0.font = .zoocBody2
            $0.textColor = .zoocGray1
        }
        
        petCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = true
        }
        
        registerButton.do {
            $0.setTitle("기록하기", for: .normal)
            $0.isEnabled = false
        }
    }
    
    private func hierarchy(){
        self.addSubviews(topBarView, cardView, registerButton)
        
        topBarView.addSubviews(xmarkButton)
        cardView.addSubviews(headerView, petCollectionView)
        headerView.addSubviews(backButton, titleLabel, subtitleLabel)
    }
    
    private func layout(){
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
        
        registerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(self.topBarView.snp.bottom).offset(55)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.84)
            $0.height.equalToSuperview().multipliedBy(0.58)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.26)
        }
        
        backButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.size.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
        }
        
        petCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
