//
//  RecordRegisterCollectionViewCell.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/01/09.
//

import UIKit

import SnapKit

final class RecordRegisterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var size: CGFloat? {
        didSet {
            profilePetImageView.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(40)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(size ?? 0)
            }
            profilePetImageView.makeCornerRound(radius: (size ?? 0)/2)
        }
    }
    
    // MARK: - UI Components
    
    private let borderView = UIView()
    private var profilePetImageView = UIImageView()
    private let profileAlphaView = UIView()
    private let petNameLabel = UILabel()
    private let selectImageView = UIImageView()
    
    // MARK: - Life Cycles
    
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        borderView.do {
            $0.backgroundColor = .zoocWhite3
        }
        
        profilePetImageView.do {
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        profileAlphaView.do {
            $0.backgroundColor = .zoocMainGreen
            $0.alpha = 0.1
            $0.isHidden = true
        }
        
        petNameLabel.do {
            $0.font = .zoocSubhead1
            $0.textColor = .zoocGray2
        }

        selectImageView.do {
            $0.image = Image.check
            $0.contentMode = .scaleAspectFill
            $0.isHidden = true
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(borderView, profilePetImageView, petNameLabel, selectImageView)
        profilePetImageView.addSubview(profileAlphaView)
    }
    private func layout() {
        borderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        profileAlphaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        petNameLabel.snp.makeConstraints {
            $0.leading.equalTo(self.profilePetImageView.snp.trailing).offset(18)
            $0.centerY.equalToSuperview()
        }
        
        selectImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(42)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(18)
            $0.height.equalTo(11)
        }
    }
    
    // MARK: - Action Method
    
    func dataBind(data: RecordRegisterModel, cellHeight: Int) {
        if let imageURL = data.petImageURL {
            profilePetImageView.kfSetImage(url: imageURL)
        } else {
            profilePetImageView.image = Image.cameraCircle
        }
        
        petNameLabel.text = data.petName
        selectImageView.isHidden = data.isSelected ? false : true
        self.size = CGFloat(cellHeight * 5/12)
    }
    
    func updateUI(isSelected: Bool){
        if isSelected {
            contentView.backgroundColor = .zoocWhite2
            profilePetImageView.layer.borderColor = UIColor.zoocMainGreen.cgColor
            profilePetImageView.layer.borderWidth = 2
            profileAlphaView.isHidden = false
            petNameLabel.textColor = .zoocMainGreen
            selectImageView.isHidden = false
        } else {
            contentView.backgroundColor = .zoocWhite1
            profilePetImageView.layer.borderColor = nil
            profilePetImageView.layer.borderWidth = 0
            profileAlphaView.isHidden = true
            petNameLabel.textColor = .zoocGray2
            selectImageView.isHidden = true
        }
    }
}
