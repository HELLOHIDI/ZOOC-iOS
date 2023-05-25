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

final class OnboardingAgreementTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    let onboardingAgreementViewModel = OnboardingAgreementViewModel()
    
    weak var delegate: CheckedButtonTappedDelegate?
    var index: Int = 0
    
    //MARK: - UI Components
    
    public var menuLabel = UILabel()
    private let seeLabel = UILabel()
    public lazy var checkedButton = BaseButton()
    
    
    //MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        target()
        
        cellStyle()
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
    
    private func cellStyle() {
        self.backgroundColor = .zoocBackgroundGreen
        self.selectionStyle = .none
        
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
    
    func dataBind(tag: Int, text: String) {
        checkedButton.tag = tag
        menuLabel.text = text
        menuLabel.asColor(targetString: "[필수]", color: .zoocMainGreen)
        
        if tag == 2 {
            seeLabel.isHidden = true
        }
    }
    
    //MARK: - Action Method
    
    @objc func checkButtonDidTap() {
        updatecheckButtonUI()
    }
}

private extension OnboardingAgreementTableViewCell {
    func updatecheckButtonUI() {
        delegate?.cellButtonTapped(index: index)
        onboardingAgreementViewModel.updateAgreementClosure?()
    }
}

