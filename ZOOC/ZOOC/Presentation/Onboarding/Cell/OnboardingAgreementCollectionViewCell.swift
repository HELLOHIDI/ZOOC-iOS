//
//  OnboardingAgreementTableViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

//MARK: - ChekedButtonTappedDelegate

protocol CheckedButtonTappedDelegate : AnyObject {
    func cellButtonTapped(index: Int)
}

final class OnboardingAgreementCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: CheckedButtonTappedDelegate?
    
    //MARK: - UI Components
    
    public var menuLabel = UILabel()
    private let seeLabel = UILabel()
    public lazy var checkedButton = BaseButton()
    
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        target()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Custom Method
    
    private func target() {
        checkedButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        self.backgroundColor = .zoocBackgroundGreen
        
        menuLabel.do {
            $0.textColor = .zoocGray3
            $0.font = .zoocBody1
            $0.textAlignment = .left
        }
        
        seeLabel.do {
            $0.text = "보기"
            $0.textColor = .zoocGray2
            $0.font = .zoocBody1
            $0.asUnderLine($0.text)
        }
        
        checkedButton.do {
            $0.setImage(Image.checkBox, for: .normal)
            $0.setImage(Image.checkBoxFill, for: .selected)
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(menuLabel,
                                seeLabel,
                                checkedButton)
    }
    
    private func layout() {
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        seeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(menuLabel.snp.trailing).offset(10)
        }
        
        checkedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }
    
    func dataBind(tag: Int, data: OnboardingAgreementModel) {
        checkedButton.tag = tag
        checkedButton.isSelected = data.isSelected
        menuLabel.text = data.title
        menuLabel.asColor(targetString: "[필수]", color: .zoocMainGreen)
        
        seeLabel.isHidden = (tag == 2)
       
    }
    
    //MARK: - Action Method
    
    @objc func checkButtonDidTap(_ sender: UIButton) {
        delegate?.cellButtonTapped(index: sender.tag)
    }
}
