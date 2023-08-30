//
//  OrderAssistantCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import UIKit

import SnapKit

final class OrderAssistantCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
   
    private var step: WithoutBankBookStep = .copy {
        didSet {
            updateUI()
        }
    }
    
    
    //MARK: - UI Components
    
    private let stepNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocSubhead1
        label.textColor = .zoocDarkGray1
        label.backgroundColor = .zoocLightGray
        label.textAlignment = .center
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocBody3
        label.textColor = .zoocDarkGray1
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.check, for: .normal)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.makeCornerRound(radius: 12)
        stepNumberLabel.makeCornerRound(ratio: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func style() {
        contentView.backgroundColor = .zoocWhite1
    }
    
    private func hierarchy() {
        contentView.addSubviews(stepNumberLabel,
                                stepLabel,
                                checkButton)
    }
    
    private func layout() {
        stepNumberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(30)
        }
        
        stepLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(stepNumberLabel.snp.trailing).offset(15)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
        
        contentView.layoutIfNeeded()
    }
    
    private func updateUI() {
        stepNumberLabel.text = String(step.rawValue)
        stepLabel.text = step.title
    }
    
    //MARK: - Piblic Methods
    
    func dataBind(_ step: WithoutBankBookStep) {
        self.step = step
    }
    
    
    //MARK: - Action Method

    
    
}
