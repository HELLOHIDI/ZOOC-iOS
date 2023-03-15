//
//  RecordMissionCollectionViewCell.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/02/04.
//

import UIKit

import SnapKit

protocol RecordMissionCollectionViewCellDelegate: AnyObject {
    func sendTapEvent(index: IndexPath)
}

final class RecordMissionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "RecordMissionCollectionViewCell"
    
    // MARK: - Properties
    
    private let placeHolderText: String = "오늘 어떤 일이 있었는지 공유해보세요"
    weak var delegate: RecordMissionCollectionViewCellDelegate?
    
    var indexPath: IndexPath?
    
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
    
    lazy var galleryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(galleryImageViewDidTap)))
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
        
        setLayout()
        contentTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
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
    
    func dataBind(model: RecordMissionModel, index: IndexPath) {
        cardQuestion.text = model.question
        indexPath = index
        if model.image == nil {
            galleryImageView.image = Image.gallery
        } else {
            galleryImageView.image = model.image
        }
        /* 여기서 UIImage에 대한 분기처리 해야 하고, text도 분기처리 해야 할 듯? */
    }
    
    //MARK: - Action Method
    
    @objc
    private func galleryImageViewDidTap(){
        // 여기서 몇번 미션 사진을 클릭한건지 인덱스(indexPath)를 보내주면 되지 않을까?
        if let index: IndexPath = indexPath {
            delegate?.sendTapEvent(index: index)
        } else {
            print("indexPath가 nil인가 봐요!")
        }
    }
}

extension RecordMissionCollectionViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = .black
        } else{
            
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolderText
            textView.textColor = .zoocGray1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // updateUI()
    }
}
