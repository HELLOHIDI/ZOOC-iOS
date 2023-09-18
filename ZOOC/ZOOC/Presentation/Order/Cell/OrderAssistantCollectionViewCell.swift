//
//  OrderAssistantCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import UIKit

import SnapKit

typealias OrderAssistantCollectionViewCellDelegate = OrderAssistantCopyViewDelegate & OrderAssistantDepositViewDelegate & OrderAssistantCompleteViewDelegate

final class OrderAssistantCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
   
    private var step: WithoutBankBookStep = .copy {
        didSet {
            updateUI()
        }
    }
    
    weak var delegate: OrderAssistantCollectionViewCellDelegate?
    
    private var totalPrice: Int = 0
    
    //MARK: - UI Components
    
    private let headerView = UIView()
    
    private let stepNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocSubhead1
        label.textColor = .zoocWhite1
        label.backgroundColor = .zoocLightGray
        label.textAlignment = .center
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocFont(font: .medium, size: 16)
        label.textColor = .zoocGray3
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.check, for: .normal)
        button.setImage(Image.checkTint, for: .selected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let copyView = OrderAssistantCopyView()
    private let depositView = OrderAssistantDepositView()
    private let completView = OrderAssistantCompleteView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        setDelegate()
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
        
        headerView.backgroundColor = .zoocWhite1
    }
    
    private func hierarchy() {
        contentView.addSubviews(copyView,
                                depositView,
                                completView,
                                headerView)
        
        headerView.addSubviews(stepNumberLabel,
                                stepLabel,
                                checkButton)
        
    }
    
    private func layout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
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
        
        copyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        depositView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        completView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.layoutIfNeeded()
        
    }
    
    private func updateUI() {
        stepNumberLabel.text = String(step.rawValue)
        stepLabel.text = step.title
    
        self.copyView.isHidden = self.step != .copy
        self.depositView.isHidden = self.step != .deposit
        self.completView.isHidden = self.step != .complete
    }
    
    private func setDelegate() {
        copyView.delegate = self
        depositView.delegate = self
        completView.delegate = self
    }
    
    //MARK: - Public Methods
    
    func dataBind(_ step: WithoutBankBookStep, totalPrice: Int) {
        self.step = step
        
        depositView.updateUI(totalPrice: totalPrice)
    }
    
}


extension OrderAssistantCollectionViewCell: OrderAssistantCopyViewDelegate {
    func copyButtonDidTap(_ fullAccount: String) {
        checkButton.isSelected = true
        delegate?.copyButtonDidTap(fullAccount)
    }
}

extension OrderAssistantCollectionViewCell: OrderAssistantDepositViewDelegate {
    func depositCompleteButtonDidTap() {
        checkButton.isSelected = true
        delegate?.depositCompleteButtonDidTap()
    }
    
    func bankButtonDidTap(_ bank: Bank) {
        delegate?.bankButtonDidTap(bank)
    }
    
    
}

extension OrderAssistantCollectionViewCell: OrderAssistantCompleteViewDelegate {
    func completeButtonDidTap() {
        delegate?.completeButtonDidTap()
    }
    
    
}
