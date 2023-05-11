//
//  HomeMainCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/05.
//

import UIKit
import Kingfisher
import SnapKit

final class HomeArchiveListCollectionViewCell : UICollectionViewCell{
    
    enum ViewType{
        case folded
        case expanded
    }
    
    //MARK: - Properties
    
    private var commentWriterData : [CommentWriterResult] = []
    
    public var viewType : ViewType = .folded
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                switch viewType {
                case .folded:
                    viewType = .expanded
                    updateUI()
                case .expanded:
                 break
                }
            } else{
                switch viewType {
                case .folded:
                    break
                case .expanded:
                    viewType = .folded
                    updateUI()
                }
            }
            
            
        }
    }
    
    //MARK: - UI Components
    
    private let petImageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let contentLabel : UILabel = {
        let label = UILabel()
        label.textColor = .zoocDarkGray1
        label.font = .zoocBody1
        label.numberOfLines = 0
        return label
    }()
    
    private let writerProfileImageView : UIImageView = {
        let view = UIImageView()
        view.image = Image.defaultProfile
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let writerLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody1
        label.textColor = .zoocGray2
        label.backgroundColor = .zoocWhite3
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocCaption
        label.textColor = .zoocGray2
        label.textAlignment = .center
        return label
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private let spacing : UIView = {
        let view = UIView()
        return view
    }()
    
    private let writerCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
        //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        setUI()
        
        setLayout()
        foldedLayout()
        foldedAlpha()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewType = .folded
        foldedAlpha()
        foldedLayout()
        foldedAnimatedLayout()
    }
    
    //MARK: - Custom Method
    

    private func register() {
        writerCollectionView.delegate = self
        writerCollectionView.dataSource = self
        
        writerCollectionView.register(HomeArchiveListWriterCollectionViewCell.self, forCellWithReuseIdentifier: HomeArchiveListWriterCollectionViewCell.cellIdentifier)
    }
    
    private func setUI() {
        contentView.backgroundColor = .zoocWhite1
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }
    
    private func setLayout() {
        
        
        contentView.addSubviews(petImageView,
                                writerCollectionView,
                                writerProfileImageView,
                                contentLabel,
                                hStackView,
                                dateLabel)
        
        hStackView.addArrangedSubViews(writerLabel, spacing)
        
        petImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.height).dividedBy(1.6)
        }
        
        writerCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.petImageView.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        writerProfileImageView.snp.makeConstraints {
            $0.bottom.equalTo(dateLabel.snp.top).offset(-9)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        
        hStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
        
        writerLabel.snp.makeConstraints {
            $0.width.equalTo(writerLabel.intrinsicContentSize.width + 14).priority(.init(751))
        }
        
        spacing.snp.makeConstraints {
            $0.size.equalTo(24).priority(.init(251))
        }
        
    
    }
    
    
    private func foldedLayout() {
        writerCollectionView.isHidden = true
        contentLabel.isHidden = true
        writerLabel.isHidden = true
        spacing.isHidden = true
    }
    
    private func foldedAlpha() {
        writerCollectionView.alpha = 0
        contentLabel.alpha = 0
        writerLabel.alpha = 0
        spacing.alpha = 0
    }
    
    
    private func expandedLayout() {
        writerCollectionView.isHidden = false
        contentLabel.isHidden = false
        writerLabel.isHidden = false
        spacing.isHidden = false
    }
    
    private func expandedAlpha() {
        writerCollectionView.alpha = 1
        contentLabel.alpha = 1
        writerLabel.alpha = 1
        spacing.alpha = 1
    }
    
    private func foldedAnimatedLayout() {
        self.writerProfileImageView.snp.remakeConstraints {
            $0.bottom.equalTo(dateLabel.snp.top).offset(-9)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        
        self.hStackView.snp.remakeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func expandedFirstAnimatedLayout() {
        self.writerProfileImageView.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.width.equalTo(24)
        }
        
        
        self.hStackView.snp.remakeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(7)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-5)
        }
        
        self.dateLabel.snp.remakeConstraints {
            $0.width.equalTo(dateLabel.intrinsicContentSize).priority(.init(990))
            $0.bottom.equalToSuperview().offset(-20)
            $0.trailing.equalToSuperview().offset(-18)
        }
        
    }
    
    private func expandedSecondAnimatedLayout() {
        
        self.expandedLayout()
        UIView.animate(withDuration: 0.2) {
            self.expandedAlpha()
        }
        
        
        
        self.contentLabel.snp.remakeConstraints {
            $0.top.equalTo(self.petImageView.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        writerLabel.snp.remakeConstraints {
            $0.width.equalTo(writerLabel.intrinsicContentSize.width + 14).priority(.init(751))
        }
        
        spacing.snp.remakeConstraints {
            $0.size.equalTo(24).priority(.init(251))
        }
        
        
    }
    private func updateUI() {
        
        switch viewType{
            
        case .folded:
            foldedLayout()
            foldedAlpha()
            UIView.animate(withDuration: 0.3, animations: {
                self.foldedAnimatedLayout()
                self.layoutIfNeeded()
            })
            
        case .expanded:
            UIView.animate(withDuration: 0.3, animations: {
                self.expandedFirstAnimatedLayout()
                self.layoutIfNeeded()
            },completion:  { _ in
                self.expandedSecondAnimatedLayout()
                self.layoutIfNeeded()
            })
        }
    }
    
    func dataBind(data: HomeArchiveModel) {
        petImageView.image = data.petImage
        contentLabel.text = data.content
        writerProfileImageView.image = data.profileImage
        writerLabel.text = data.writerName
        dateLabel.text = data.date
    }
    
    func dataBind(data: HomeArchiveResult) {
        
        if data.record.writerPhoto == nil {
            self.writerProfileImageView.image = Image.defaultProfile
        } else {
            self.writerProfileImageView.kfSetImage(url: data.record.writerPhoto ?? "")
        }
        
        
        petImageView.kfSetImage(url: data.record.photo)
        
        
        
        
        contentLabel.text = data.record.content
        writerLabel.text = data.record.writerName
        dateLabel.text = data.record.date
        commentWriterData = data.commentWriters
    }
    
    func updateWriterCollectionViewCell() {
        writerCollectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDataSource
extension HomeArchiveListCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentWriterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeArchiveListWriterCollectionViewCell.cellIdentifier, for: indexPath) as? HomeArchiveListWriterCollectionViewCell else { return UICollectionViewCell() }
        cell.dataBind(data: commentWriterData[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeArchiveListCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    
}

