//
//  ArchiveView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/04.
//

import UIKit

import SnapKit
import Then

final class ArchiveView: UIView {
    
    //MARK: - Properties
    
    var scrollDown = false
    
    //MARK: - UI Components
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let backButton = UIButton()
    let etcButton = UIButton()
    
    let petImageView = UIImageView()
    
    let dateLabel = UILabel()
    let writerImageView = UIImageView()
    let writerNameLabel = UILabel()
    let contentLabel = UILabel()
    let lineView = UIView()

    let commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    let commentView = ArchiveCommentView()
    
    //MARK: - Life Cycle
    
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
        
        scrollView.do {
            $0.bounces = false
            $0.showsVerticalScrollIndicator = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentInsetAdjustmentBehavior = .never
        }
        
        backButton.do {
            $0.setImage(Image.xmarkWhite, for: .normal)
            $0.tintColor = .white
        }
        
        etcButton.do {
            $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            $0.tintColor = .white
        }
        
        petImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }
        
        dateLabel.do {
            $0.font = .zoocBody1
            $0.textColor = .zoocGray2
        }
        
        writerImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
        
        writerNameLabel.do {
            $0.font = .zoocBody1
            $0.textColor = .zoocGray2
        }
        
        contentLabel.do {
            $0.font = .zoocBody3
            $0.textColor = .zoocDarkGray2
        }
        
        lineView.do {
            $0.backgroundColor = .zoocLightGray
        }
        
        commentCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
        }
        
    }
    
    private func hierarchy() {
        
        addSubviews(scrollView,
                         commentView)
        
        scrollView.addSubview(contentView)
        
        
        contentView.addSubviews(petImageView,
                                backButton,
                                etcButton,
                                dateLabel,
                                writerImageView,
                                writerNameLabel,
                                contentLabel,
                                lineView,
                                commentCollectionView)
    }
    
    private func layout() {
  
        //MARK: view Layout
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        commentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(19)
            $0.height.equalTo(77)
        }
        
        //MARK: scrollView Layout
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        //MARK: contentView Layout
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(42)
        }
        
        etcButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.width.equalTo(42)
        }
        
        petImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(petImageView.snp.width)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(petImageView.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(30)
        }
        
        writerImageView.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalTo(writerNameLabel.snp.leading).offset(-10)
            $0.height.width.equalTo(24)
        }
        
        writerNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerImageView)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        commentCollectionView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(450)
        }
    }
    
    func updateArchiveUI(_ data: ArchiveResult?) {
        if let imageURL = data?.record.writerPhoto{
            self.writerImageView.kfSetImage(url: imageURL)
        } else {
            self.writerImageView.image = Image.defaultProfile
        }
        
        self.petImageView.kfSetImage(url: data?.record.photo)
        self.dateLabel.text = data?.record.date
        self.writerNameLabel.text = data?.record.writerName
        self.contentLabel.text = data?.record.content
    }
    
    
    func updateCommentsUI(_ data: [CommentResult]) {
        commentCollectionView.reloadData()
        commentCollectionView.layoutIfNeeded()
        commentCollectionView.snp.updateConstraints {
            let contentHeight = self.commentCollectionView.contentSize.height
            let height = (contentHeight > 450 ) ? contentHeight : 450
            $0.height.greaterThanOrEqualTo(height)
        }
        
        if scrollDown{
            scrollView.layoutSubviews()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.scrollView.setContentOffset(CGPoint(x: 0,
                                                         y: self.scrollView.contentSize.height - self.scrollView.bounds.height),
                                                 animated: true)
            }
        } else {
            scrollDown = true
        }
        
    }
    
    
}
