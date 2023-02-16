//
//  RecordMissionCollectionViewCell.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/02/04.
//

import UIKit

import SnapKit

final class RecordMissionCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    // MARK: - Identifier
    
    static let identifier = "RecordMissionCollectionViewCell"
    
    // MARK: - Properties
    
    private let placeHolderText: String = "오늘 어떤 일이 있었는지 공유해보세요"
    
    // MARK: - UI Components
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.zoocSubGreen.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 14
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.backgroundColor = .white
        return view
    }()
    
    private let cardQuestion: UILabel = {
        let label = UILabel()
        label.textColor = .zoocDarkGray2
        label.font = .zoocSubhead1
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let galleryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.gallery
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 18.0, bottom: 16.0, right: 18.0)
        textView.font = .zoocBody2
        textView.text = placeHolderText
        textView.textColor = .zoocGray1
        textView.backgroundColor = .zoocWhite2
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 12
        return textView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gesture()
        setLayout()
        contentTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func gesture(){
        // 임시로 비워뒀습니다
    }
    
    private func setLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubviews(cardQuestion, galleryImageView, contentTextView)
        
        cardContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cardQuestion.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        galleryImageView.snp.makeConstraints {
            $0.top.equalTo(cardQuestion.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(210)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(galleryImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(135)
        }
    }
    
    func dataBind(model: RecordMissionModel) {
        cardQuestion.text = model.question
    }
}
