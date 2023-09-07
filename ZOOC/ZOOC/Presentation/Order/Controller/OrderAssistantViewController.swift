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
    
    private var totalPrice: Int
    
    private var currentStep: WithoutBankBookStep = .copy {
        didSet {
            collectionView.performBatchUpdates(nil)
        }
    }
    
    //MARK: - UI Components
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.xmark, for: .normal)
        button.addTarget(self,
                         action: #selector(dismissButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    init(totalPrice: Int) {
        self.totalPrice = totalPrice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                         collectionView)
    }
    
    private func layout() {
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(42)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
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
        
        collectionView.register(OrderAssistantHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OrderAssistantHeaderView.reuseCellIdentifier)
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
        cell.dataBind(WithoutBankBookStep.allCases[indexPath.row],
                      totalPrice: totalPrice)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
              let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: OrderAssistantHeaderView.reuseCellIdentifier,
                for: indexPath) as! OrderAssistantHeaderView

              return view
            default:
              return UICollectionReusableView()
            }
    }
    
    
}

extension OrderAssistantViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 60
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width - 60
        var height: CGFloat = 60
        
        if currentStep.rawValue == indexPath.row + 1 {
            height = currentStep.cellHeight
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}


extension OrderAssistantViewController: OrderAssistantCollectionViewCellDelegate {
    
    //MARK: - Copy
    func copyButtonDidTap(_ fullAccount: String) {
        UIPasteboard.general.string = fullAccount + "\(totalPrice)원"
        showToast("계좌번호가 복사 완료 되었어요", type: .good)
        currentStep = .deposit
    }

    //MARK: - Deposit
    func depositCompleteButtonDidTap() {
        currentStep = .complete
    }
    
    func bankButtonDidTap(_ bank: Bank) {
        guard let url = URL(string: bank.urlSchema) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        }
    }
    
    //MARK: - Complete
    
    func completeButtonDidTap() {
        dismiss(animated: true)
    }
    
}


