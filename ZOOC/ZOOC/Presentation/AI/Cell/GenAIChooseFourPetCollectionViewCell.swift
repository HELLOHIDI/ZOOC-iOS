//
//  df.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import SnapKit


final class GenAIChooseFourPetCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var size: CGFloat? {
        didSet {
            guard let size = self.size else { return }
            profilePetImageView.snp.updateConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.size.equalTo(size)
            }
            profilePetImageView.makeCornerRound(radius: size / 2)
        }
    }
    
    // MARK: - UI Components
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocWhite3
        return view
    }()
    
    private let selectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.checkTint
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    private var profilePetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let profileAlphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocMainGreen
        view.alpha = 0.1
        view.isHidden = true
        return view
    }()
    
    private let petNameLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocSubhead1
        label.textColor = .zoocGray2
        return label
    }()
    
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
        
        selectImageView.do {
            $0.image = Image.checkTint
            $0.contentMode = .scaleAspectFill
            $0.isHidden = true
        }
        
        profilePetImageView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 25
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
        
        selectImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(28)
            $0.width.equalTo(18)
            $0.height.equalTo(11)
        }
        
        profileAlphaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        petNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.profilePetImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Action Method
    
    func dataBind(data: RecordRegisterModel, cellHeight: Int) {

        if let imageURL = data.petImageURL{
            profilePetImageView.kfSetImage(url: imageURL)
        } else {
            profilePetImageView.image = Image.defaultProfile
        }

        petNameLabel.text = data.petName
        selectImageView.isHidden = data.isSelected ? false : true
        self.size = CGFloat(cellHeight * 5/12)

        if data.isSelected {
            contentView.backgroundColor = .zoocWhite2
            profilePetImageView.layer.borderColor = UIColor.zoocMainGreen.cgColor
            profilePetImageView.layer.borderWidth = 2
            profileAlphaView.isHidden = false
            petNameLabel.textColor = .zoocMainGreen
            selectImageView.isHidden = false
        } else {
            contentView.backgroundColor = .zoocWhite1
            profilePetImageView.layer.borderColor = UIColor.clear.cgColor
            profilePetImageView.layer.borderWidth = 0
            profileAlphaView.isHidden = true
            petNameLabel.textColor = .zoocGray2
            selectImageView.isHidden = true
        }
    }
}

