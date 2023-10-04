//
//  OnboardingAgreementTableHeaderView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

//MARK: - AllChekedButtonTappedDelegate

protocol AllChekedButtonTappedDelegate : AnyObject {
    func allCellButtonTapped()
}

final class OnboardingAgreementCollectionHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: AllChekedButtonTappedDelegate?
    
    //MARK: - UI Components
    
    public var allAgreementView = UIView()
    private var allAgreementLabel = UILabel()
    public lazy var allCheckedButton = BaseButton()
    
    //MARK: - Life Cycle
    
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
        allCheckedButton.addTarget(self, action: #selector(checkedButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        self.backgroundColor = .zoocBackgroundGreen
        
        allAgreementView.do {
            $0.makeCornerRound(radius: 12)
            $0.backgroundColor = .white
            $0.setBorder(borderWidth: 1, borderColor: UIColor.zoocLightGray)
        }
        
        allAgreementLabel.do {
            $0.text = "전체 동의"
            $0.textColor = .zoocMainGreen
            $0.font = .zoocSubhead1
            $0.textAlignment = .left
        }
        
        allCheckedButton.do {
            $0.setImage(Image.checkBox, for: .normal)
            $0.setImage(Image.checkBoxFill, for: .selected)
        }
    }
    
    private func hierarchy() {
        self.addSubview(allAgreementView)
        allAgreementView.addSubviews(allAgreementLabel, allCheckedButton)
    }
    
    private func layout() {
        allAgreementView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(50)
        }
        
        allAgreementLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(18)
        }
        
        allCheckedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }
    
    //MARK: - Action Method
    
    @objc func checkedButtonDidTap() {
        delegate?.allCellButtonTapped()
    }
}

