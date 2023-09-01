//
//  ProductBottomSheet.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

final class ProductBottomSheet: UIViewController, ScrollableViewController {
    
    //MARK: - Properties

    
    
    //MARK: - UI Components
    
    private let collectionView: SelfSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = SelfSizingCollectionView(maxHeight: UIScreen.main.bounds.height * 0.6,
                                                      layout: layout)
        collectionView.allowsSelection = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.indicatorStyle = .black
        return collectionView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocLightGray
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 금액"
        label.font = .zoocSubhead1
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.text = 999.priceText
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setTitle("장바구니", for: .normal)
        button.setTitleColor(.zoocMainGreen, for: .normal)
        button.setBorder(borderWidth: 1, borderColor: .zoocMainGreen)
        button.makeCornerRound(radius: 6)
        button.titleLabel?.font = .zoocSubhead1
        button.backgroundColor = .zoocWhite1
        button.addTarget(self,
                         action: #selector(cartButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.setTitleColor(.zoocWhite1, for: .normal)
        button.setBorder(borderWidth: 1, borderColor: .zoocMainGreen)
        button.titleLabel?.font = .zoocSubhead1
        button.backgroundColor = .zoocMainGreen
        button.makeCornerRound(radius: 6)
        button.addTarget(self,
                         action: #selector(buyButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    var scrollView: UIScrollView {
        collectionView
    }
    
    //MARK: - Life Cycle

        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        register()
        setDelegate()
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Custom Method
    
    private func register() {
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
    }
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func style() {
        
    }
    
    private func hierarchy() {
        view.addSubviews(collectionView,
                         lineView,
                         priceLabel,
                         priceValueLabel,
                         hStackView)
        
        hStackView.addArrangedSubViews(cartButton,
                                       buyButton)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(lineView)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalTo(priceLabel.snp.top).offset(-15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        
        priceLabel.snp.makeConstraints {
            $0.bottom.equalTo(cartButton.snp.top).offset(-25)
            $0.leading.equalToSuperview().inset(20)
        }
        
        priceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        hStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(47)
        }
    }
    
    @objc
    private func cartButtonDidTap() {
        print(#function)
    }
    
    @objc
    private func buyButtonDidTap() {
        print(#function)
    }
}


//MARK: - UICollectionViewDataSource
extension ProductBottomSheet: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemPink
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductBottomSheet: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

