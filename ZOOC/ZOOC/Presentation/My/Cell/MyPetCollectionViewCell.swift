//
//  AnimalCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/01.
//

import UIKit

final class MyPetCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    public var petImageView = UIImageView()
    public var petNameLabel = UILabel()
    
    //MARK: - Life Cycles
    
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
        contentView.do {
            $0.backgroundColor = .zoocWhite2
            $0.makeCornerRound(radius: 21)
            $0.makeCornerBorder(borderWidth: 1, borderColor: .zoocLightGray)
        }
        
        petImageView.do {
            $0.image = Image.mockPet2
            $0.layer.cornerRadius = 17
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        petNameLabel.do {
            $0.font = .zoocCaption
            $0.textColor = .zoocDarkGray1
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(petImageView, petNameLabel)
    }
    
    private func layout() {
        petImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(3)
            $0.size.equalTo(34)
        }
        
        petNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.petImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(14)
        }
    }
    
    public func dataBind(data: PetResult) {
        petNameLabel.text = data.name
        data.photo == nil ? setDefaultPetProfileImage() : setPetMemberProfileImage(photo: data.photo!)
    }
    
    func sizeFittingWith(cellHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: cellHeight)
        return self.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .fittingSizeLevel,
                                                        verticalFittingPriority: .required)
    }
}

extension MyPetCollectionViewCell {
    func setDefaultPetProfileImage() {
        petImageView.image = Image.cameraCircle
    }
    
    func setPetMemberProfileImage(photo: String) {
        petImageView.kfSetImage(url: photo)
    }
}

