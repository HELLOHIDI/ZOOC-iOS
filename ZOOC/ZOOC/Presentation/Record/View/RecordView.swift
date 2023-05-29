//
//  RecordView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/05/12.
//

import UIKit

import SnapKit
import Then

final class RecordView: UIView {
    
    //MARK: - Properties
    
    var petImage: UIImage?
    private var recordData = RecordMissionModel()
    private let placeHoldText: String = """
                                        ex) 2023년 2월 30일
                                        가족에게 어떤 순간이었는지 남겨주세요
                                        """
    var contentTextViewIsRegistered: Bool = false
    
    //MARK: - UI Components
    
    private let topBarView = UIView()
    public lazy var xmarkButton = UIButton()
    private let buttonsContainerView = UIView()
    private lazy var dailyButton = UIButton()
    public lazy var missionButton = UIButton()
    private let cardView = UIView()
    public let galleryImageView = UIImageView()
    public lazy var contentTextView = UITextView()
    public lazy var nextButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func style() {
        
        xmarkButton.do {
            $0.setImage(Image.xmark, for: .normal)
        }

        dailyButton.do {
            $0.setTitle("일상", for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.setTitleColor(.zoocDarkGray1, for: .normal)
        }

        missionButton.do {
            $0.setTitle("미션", for: .normal)
            $0.titleLabel?.font = .zoocSubhead1
            $0.setTitleColor(.zoocGray1, for: .normal)
        }

        cardView.do {
            $0.layer.cornerRadius = 24
            $0.layer.shadowColor = UIColor.zoocSubGreen.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 14
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.backgroundColor = .white
        }
        
        galleryImageView.do {
            $0.image = Image.gallery
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 12
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
        }

        
        contentTextView.do {
            $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 18.0, bottom: 16.0, right: 18.0)
            $0.font = .zoocBody2
            $0.text = placeHoldText
            $0.textColor = .zoocGray1
            $0.backgroundColor = .zoocWhite2
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
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
        self.addSubviews(topBarView, cardView, nextButton)
        topBarView.addSubviews(xmarkButton, buttonsContainerView)
        buttonsContainerView.addSubviews(dailyButton, missionButton)
        cardView.addSubviews(galleryImageView, contentTextView)
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
            $0.height.equalTo(54)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(self.topBarView.snp.bottom).offset(55)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(self.nextButton).inset(135)
        }
        
        galleryImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(210)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(self.galleryImageView.snp.bottom).offset(12)
            $0.bottom.leading.trailing.equalToSuperview().inset(22)
        }
    }
}
