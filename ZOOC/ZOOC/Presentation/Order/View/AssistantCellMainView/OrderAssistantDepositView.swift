//
//  OrderDepositStepView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/31.
//

import UIKit

import SnapKit
import FirebaseRemoteConfig

protocol OrderAssistantDepositViewDelegate: AnyObject {
    func bankButtonDidTap(_ bank: Bank)
    func depositCompleteButtonDidTap()
}

final class OrderAssistantDepositView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: OrderAssistantDepositViewDelegate?
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray2
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var completeButton: ZoocGradientButton = {
        let button = ZoocGradientButton(.medium)
        button.setTitle("결제 완료했습니다", for: .normal)
        button.addTarget(self,
                         action: #selector(completeButtonDidTap),
                         for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    
    //MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
        register()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI & Layout
    
    private func style() {
        backgroundColor = .zoocWhite1
    }
    
    private func hierarchy() {
        addSubviews(titleLabel,
                    collectionView,
                    completeButton)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        completeButton.snp.makeConstraints {
            $0.height.equalTo(47)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func register() {
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func showCompleteButton() {
        UIView.animate(withDuration: 1) {
            self.completeButton.alpha = 1
        }
    }
    
    //MARK: - Public Methods
    
    func updateUI(totalPrice: Int) {
        titleLabel.text = "원하시는 금융앱에서\n\(totalPrice.priceText)을 입금해주세요"
        titleLabel.asColor(targetString: totalPrice.priceText,
                           color: .zoocMainGreen)
    }
    
    //MARK: - Action Method

    
    @objc private func completeButtonDidTap() {
        delegate?.depositCompleteButtonDidTap()
    }
    
}

extension OrderAssistantDepositView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Bank.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = UIImageView(image: Image.load(Bank.allCases[indexPath.row]))
        
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        cell.layoutIfNeeded()
        imageView.makeCornerRound(ratio: 6)
        
        return cell
    }
    
}

extension OrderAssistantDepositView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        delegate?.bankButtonDidTap(Bank.allCases[indexPath.row])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showCompleteButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 60, bottom: 20, right: 60)
    }
    
}
