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
    private let nextButton = UIButton()
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
        
        nextButton.do {
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .zoocGray1
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
        }
        
        menuLabel.do {
            $0.textColor = .zoocGray3
            $0.font = .zoocBody1
            $0.textAlignment = .left
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(menuLabel, nextButton, checkedButton)
    }
    
    private func layout() {
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
//        nextButton.snp.makeConstraints {
//            $0.centerY.equalTo(menuLabel)
//            $0.leading.equalTo(menuLabel.snp.trailing).offset(10)
//            $0.size.equalTo(14)
//        }
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(menuLabel)
            $0.trailing.equalTo(checkedButton.snp.leading).offset(-15)
            $0.size.equalTo(14)
        }
        
        checkedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
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

