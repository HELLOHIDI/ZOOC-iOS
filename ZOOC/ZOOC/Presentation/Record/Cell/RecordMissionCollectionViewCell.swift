//
//  RecordMissionCollectionViewCell.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/02/04.
//

import UIKit

import SnapKit

protocol RecordMissionCollectionViewCellDelegate: AnyObject {
    func sendTapEvent(tag: Int)
}

final class RecordMissionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let placeHolderText: String = "오늘 어떤 일이 있었는지 공유해보세요"
    weak var delegate: RecordMissionCollectionViewCellDelegate?
    
    var missonID: Int?
    var enableNextButton: Bool = false
    
    // MARK: - UI Components
    
    private let cardContainerView = UIView()
    private let cardQuestion = UILabel()
    lazy var galleryImageView = UIImageView()
    lazy var contentTextView = UITextView()
    
    // MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .clear
            $0.contentView.backgroundColor = .clear
        }
        
        cardContainerView.do {
            $0.layer.cornerRadius = 24
            $0.layer.shadowColor = UIColor.zoocSubGreen.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 14
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.backgroundColor = .white
        }
        
        cardQuestion.do {
            $0.textColor = .zoocDarkGray2
            $0.font = .zoocSubhead1
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        galleryImageView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 12
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(galleryImageViewDidTap)))
        }
        
        contentTextView.do {
            $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 18.0, bottom: 16.0, right: 18.0)
            $0.font = .zoocBody2
            $0.text = placeHolderText
            $0.textColor = .zoocGray1
            $0.backgroundColor = .zoocWhite2
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
    }
    
    private func hierarchy() {
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubviews(cardQuestion, galleryImageView, contentTextView)
    }
    
    private func layout() {
        cardContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cardQuestion.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        galleryImageView.snp.makeConstraints {
            $0.bottom.equalTo(contentTextView.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(210)
        }
        
        contentTextView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(135)
        }
    }
    
    
    func dataBind(model: RecordMissionListModel) {
        cardQuestion.text = model.mission_content
        self.missonID = model.id
    }
    
    //MARK: - Action Method
    
    @objc private func galleryImageViewDidTap() {
        guard let missonID = missonID else {
            print("indexPath가 nil인가 봐요!")
            return
        }
        delegate?.sendTapEvent(tag: missonID)
    }
}

