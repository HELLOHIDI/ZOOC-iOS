//
//  MyRegisteredPetTableViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/11.
//

import UIKit

final class MyRegisteredPetTableViewCell: UITableViewCell {
    
    //MARK: - UI Components
    
    public lazy var petProfileButton = UIButton()
    public var petProfileNameLabel = UILabel()
    
    //MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellStyle()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func cellStyle() {
        self.backgroundColor = .zoocWhite2
        
        petProfileButton.do {
            $0.makeCornerRound(radius: 30)
            $0.imageView?.contentMode = .scaleAspectFill
        }
        
        petProfileNameLabel.do {
            $0.textColor = .zoocDarkGreen
            $0.font = .zoocSubhead1
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(petProfileButton, petProfileNameLabel)
    }
    
    private func layout() {
        petProfileButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(60)
        }
        
        petProfileNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.petProfileButton.snp.trailing).offset(9)
            $0.width.equalTo(196)
            $0.height.equalTo(36)
        }
    }
    
    func dataBind(data: PetResult) {
        petProfileNameLabel.text = data.name
        data.photo == nil ? setDefaultPetProfileImage() : setPetMemberProfileImage(photo: data.photo!)
    }
    
    //MARK: - Action Method
}

extension MyRegisteredPetTableViewCell {
    func setDefaultPetProfileImage() {
        petProfileButton.setImage(Image.cameraCircle, for: .normal)
    }
    
    func setPetMemberProfileImage(photo: String) {
        petProfileButton.kfSetButtonImage(url: photo)
    }
}



