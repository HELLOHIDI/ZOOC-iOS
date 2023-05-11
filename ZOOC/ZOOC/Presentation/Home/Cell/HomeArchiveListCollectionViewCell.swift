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
        
        var isHidden: Bool {
            switch self{
            case .folded:
                return true
            case .expanded:
                return false
            }
        }
        
        var alpha: CGFloat {
            switch self{
            case .folded:
                return 0
            case .expanded:
                return 1
            }
        }
    }
    
    //MARK: - Properties
    
    private var commentWriterData : [CommentWriterResult] = [] {
        didSet {
            writerCollectionView.reloadData()
        }
    }
    
    public var viewType : ViewType = .folded {
        didSet {
            updateUI()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                switch viewType {
                case .folded:
                    viewType = .expanded
                case .expanded:
                    break
                }
            } else{
                switch viewType {
                case .folded:
                    break
                case .expanded:
                    viewType = .folded
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
        style()
        hierarchy()
        layout()
        
        updateHidden()
        updateAlpha()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewType = .folded
    }
    
    //MARK: - Custom Method
    

    private func register() {
        writerCollectionView.delegate = self
        writerCollectionView.dataSource = self
        
        writerCollectionView.register(HomeArchiveListWriterCollectionViewCell.self, forCellWithReuseIdentifier: HomeArchiveListWriterCollectionViewCell.cellIdentifier)
    }
    
    private func style() {
        contentView.backgroundColor = .zoocWhite1
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }
    
    private func hierarchy() {
        contentView.addSubviews(petImageView,
                                    writerCollectionView,
                                    writerProfileImageView,
                                    contentLabel,
                                    hStackView,
                                    dateLabel)
        
        hStackView.addArrangedSubViews(writerLabel, spacing)
    }
    
    private func layout() {
        
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
    
    private func updateUI() {
        
        updateHidden()
        
        switch viewType{
            
        case .folded:
            updateAlpha()
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
    
    
    private func updateHidden() {
        writerCollectionView.isHidden = viewType.isHidden
        contentLabel.isHidden = viewType.isHidden
        writerLabel.isHidden = viewType.isHidden
        spacing.isHidden = viewType.isHidden
    }
    
    private func updateAlpha() {
        writerCollectionView.alpha = viewType.alpha
        contentLabel.alpha = viewType.alpha
        writerLabel.alpha = viewType.alpha
        spacing.alpha = viewType.alpha
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
        
        UIView.animate(withDuration: 0.2) {
            self.updateAlpha()
        }
        
        contentLabel.snp.remakeConstraints {
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

