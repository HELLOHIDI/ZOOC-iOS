//
//  ShopProductView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import UIKit

import SnapKit
import Then

final class ShopProductView: UIView {
    
    //MARK: - UI Components
    
     let productBottomSheet = ProductBottomSheet()
     lazy var productBottomSheetVC = BottomSheetViewController(isTouchPassable: false,
                                                               contentViewController: productBottomSheet)
     let scrollView = UIScrollView()
     let contentView = UIView()
     let backButton = UIButton()
     let cartButton = UIButton()
     let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Device.width, height: Device.width / 375 * 219)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        collectionView.register(ProductImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductImageCollectionViewCell.reuseCellIdentifier)
        return collectionView
    }()
    
    lazy var pageControl = UIPageControl()
    
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let buyView = UIView()
    let buyButton = ZoocGradientButton(.capsule)
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        
        scrollView.do {
            $0.bounces = false
            $0.showsVerticalScrollIndicator = false
        }
        
        backButton.do {
            $0.setImage(Image.back, for: .normal)
            $0.tintColor = .zoocDarkGray1
        }
        
        cartButton.do {
            $0.setImage(Image.cart, for: .normal)
        }
        
        pageControl.do {
            $0.currentPageIndicatorTintColor = .zoocMainGreen
            $0.pageIndicatorTintColor = .zoocGray1
            $0.currentPage = 0
            $0.backgroundStyle = .minimal
            $0.allowsContinuousInteraction = false
        }
        
        nameLabel.do {
            $0.font = .zoocFont(font: .medium, size: 20)
            $0.textColor = .zoocDarkGray2
        }
        
        priceLabel.do {
            $0.font = .zoocFont(font: .semiBold, size: 20)
            $0.textColor = .zoocDarkGray2
        }
        
        descriptionLabel.do {
            $0.font = .zoocBody3
            $0.textColor = .zoocGray2
            $0.numberOfLines = 0
        }
        
        buyButton.do {
            $0.setTitle("구매하기", for: .normal)
        }
        
    }
    
    private func hierarchy() {
        
        addSubviews(backButton,
                         cartButton,
                         scrollView,
                         buyView)
        
        scrollView.addSubview(contentView)
        
        
        contentView.addSubviews(imageCollectionView,
                                pageControl,
                                nameLabel,
                                priceLabel,
                                descriptionLabel)
        
        buyView.addSubviews(buyButton)
    }
    
    private func layout() {
  
        //MARK: view Layout
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        cartButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(11)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        buyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(77)
        }
        
        //MARK: scrollView Layout
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        //MARK: contentView Layout
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.width / 375 * 219)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(imageCollectionView)
            $0.horizontalEdges.equalTo(imageCollectionView)
            $0.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(40)
        }
        
        buyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(37)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
    }
    
    //MARK: - Custom Method
    
    func updateUI(_ data: ProductDetailResult?) {
        imageCollectionView.reloadData()
        pageControl.numberOfPages = data?.images.count ?? 0
        
        priceLabel.text = data?.price.priceText
        nameLabel.text = data?.name
        descriptionLabel.text = data?.description
    }
}

