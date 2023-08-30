//
//  OrderPayViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import UIKit

import SnapKit
import Then

final class OrderAssistantViewController : BaseViewController {
    
    //MARK: - Properties
    
    private let currentStep: WithoutBankBookStep = .copy
    
    //MARK: - UI Components
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.xmark, for: .normal)
        button.addTarget(self,
                         action: #selector(dismissButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "무통장 입금을 도와드릴게요"
        label.textColor = .zoocDarkGray1
        label.textAlignment = .center
        label.font = .zoocHeadLine
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        delegate()
        register()
    }
    
    //MARK: - Custom Method
    
    private func style() {
        
    }
    
    private func hierarchy() {
        view.addSubviews(dismissButton,
                         titleLabel,
                         collectionView)
    }
    
    private func layout() {
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(86)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func delegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func register() {
        collectionView.register(OrderAssistantCollectionViewCell.self,
                                forCellWithReuseIdentifier: OrderAssistantCollectionViewCell.cellIdentifier)
    }
    
    //MARK: - Action Method
    
    @objc private func dismissButtonDidTap() {
        dismiss(animated: true)
    }
    
}

extension OrderAssistantViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        WithoutBankBookStep.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderAssistantCollectionViewCell.cellIdentifier,
                                                      for: indexPath) as! OrderAssistantCollectionViewCell
        cell.dataBind(WithoutBankBookStep.allCases[indexPath.row])
        return cell
    }
    
    
}

extension OrderAssistantViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width - 60
        let height: CGFloat = 60
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}
