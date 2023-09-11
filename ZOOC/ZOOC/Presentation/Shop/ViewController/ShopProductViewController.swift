//
//  ShopProductViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

import SnapKit
import Then
import FloatingPanel

final class ShopProductViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var productData: ProductDetailResult? {
        didSet{
            updateUI()
            productBottomSheet.dataBind(productData)
        }
    }
    
    
    //MARK: - UI Components
    
    private let productBottomSheet = ProductBottomSheet()
    private lazy var productBottomSheetVC = BottomSheetViewController(isTouchPassable: false,
                                                                      contentViewController: productBottomSheet)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backButton = UIButton()
    private let cartButton = UIButton()
    
    private let imageCollectionView: UICollectionView = {
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
    
    private lazy var pageControl = UIPageControl()
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let buyView = UIView()
    private let buyButton = ZoocGradientButton(.capsule)
    
    //MARK: - Life Cycle
    
    init(productID: Int){
        super.init(nibName: nil, bundle: nil)
        
        requestDetailProductAPI(id: productID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        gesture()
        
        style()
        hierarchy()
        layout()
    }

    //MARK: - Custom Method

    
    private func setDelegate() {
        productBottomSheet.delegate = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func gesture() {
        backButton.addTarget(self,
                             action: #selector(backButtonDidTap),
                             for: .touchUpInside)
        
        cartButton.addTarget(self,
                             action: #selector(naviCartButtonDidTap),
                             for: .touchUpInside)
        
    }
    
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
            $0.addTarget(self,
                         action: #selector(buyButtonDidTap),
                         for: .touchUpInside)
        }
        
    }
    
    private func hierarchy() {
        
        view.addSubviews(backButton,
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        cartButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11)
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
    
    private func updateUI() {
        imageCollectionView.reloadData()
        pageControl.numberOfPages = productData?.images.count ?? 0
        
        priceLabel.text = productData?.price.priceText
        nameLabel.text = productData?.name
        descriptionLabel.text = productData?.description
    }
    
    private func requestDetailProductAPI(id: Int) {
        ShopAPI.shared.getProduct(productID: id) { result in
            guard let result = self.validateResult(result) as? ProductDetailResult else { return }
            self.productData = result
        }
    }
    
    //MARK: - API Method
    
    
    //MARK: - Action Method
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func naviCartButtonDidTap() {
        let cartVC = ShopCartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc
    private func buyButtonDidTap() {
        present(productBottomSheetVC, animated: true)
    }
}

extension ShopProductViewController: ProductBottomSheetDelegate {
    func cartButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        guard let productData else { return }
        
        selectedProductOptions.forEach {
            let cartedProduct = CartedProduct(product: productData,
                                               selectedProduct: $0)
            DefaultRealmService.shared.setCartedProduct(cartedProduct)
        }
       
        showToast("장바구니에 상품이 담겼습니다.",
                  type: .good,
                  bottomInset: 86)
    }
    
    func orderButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        guard let productData else { return }
        var orderProducts: [OrderProduct] = []
        selectedProductOptions.forEach {
            orderProducts.append(OrderProduct(product: productData,
                                              selectedProductOption: $0))
        }
        let orderVC = OrderViewController(orderProducts)
        navigationController?.pushViewController(orderVC, animated: true)
    }
    
    
}

extension ShopProductViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.productData?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.reuseCellIdentifier,
                                                      for: indexPath) as! ProductImageCollectionViewCell
        cell.dataBind(image: productData?.images[indexPath.row])
        return cell
    }
}

extension ShopProductViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Device.width
        let index = round(scrolledOffsetX / cellWidth)
        pageControl.currentPage = Int(index)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left,
                                              y: scrollView.contentInset.top)
    }
}
