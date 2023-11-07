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
    
    public lazy var checkedButton = BaseButton()
    public var menuLabel = UILabel()
    private let seeLabel = UILabel()
    
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
        checkedButton.do {
            $0.setImage(.zwImage(.btn_checkbox), for: .normal)
            $0.setImage(.zwImage(.btn_checkbox_fill), for: .selected)
        }
        menuLabel.do {
            $0.textColor = .zw_black
            $0.font = .zw_Body1
            $0.textAlignment = .left
        }
        seeLabel.do {
            $0.text = "보기"
            $0.textColor = .zw_lightgray
            $0.font = .zw_caption
            $0.asUnderLine($0.text)
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(
            checkedButton,
            menuLabel,
            seeLabel
        )
    }
    
    private func layout() {
        checkedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(36)
        }
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkedButton.snp.trailing).offset(4)
        }
        seeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    func dataBind(tag: Int, data: OnboardingAgreementModel) {
        checkedButton.tag = tag
        checkedButton.isSelected = data.isSelected
        menuLabel.text = data.title
    }
    
    //MARK: - Action Method
    
    @objc func checkButtonDidTap(_ sender: UIButton) {
        delegate?.cellButtonTapped(index: sender.tag)
    }
}
