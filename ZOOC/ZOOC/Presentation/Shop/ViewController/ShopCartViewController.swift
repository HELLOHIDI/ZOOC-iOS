//
//  ShopCartViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/05.
//

import UIKit

import FirebaseRemoteConfig
import SnapKit
import Then

final class ShopCartViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var deliveryFee: Int = 4000 {
        didSet {
            updateUI()
        }
    }
    
//    private var selectedProductData: [SelectedProductOption] {
//        didSet {
//            collectionView.reloadData()
//            updateUI()
//        }
//    }
    
    private var cartedProducts: [CartedProduct] = [] {
        didSet {
            collectionView.reloadData()
            updateUI()
        }
    }
    
    //MARK: - UI Components
    
    private lazy var backButton: UIButton =  {
        let button = UIButton()
        button.setImage(Image.back, for: .normal)
        button.addTarget(self,
                         action: #selector(backButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주문하기"
        label.font = .zoocHeadLine
        label.textColor = .zoocDarkGray2
        label.textAlignment = .left
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ShopCartCollectionViewCell.self,
                                forCellWithReuseIdentifier: ShopCartCollectionViewCell.reuseCellIdentifier)
        return collectionView
    }()
    
    private let bottomView = UIView()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocLightGray
        return view
    }()
    
    private let paymentInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "결제 정보"
        label.font = .zoocSubhead2
        label.textColor = .zoocDarkGray2
        return label
    }()
    
    
    private let productsPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "상품 가격"
        label.font = .zoocFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        return label
    }()
    
    private let productsPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        label.textAlignment = .right
        return label
    }()
    
    private let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.text = "배송비"
        label.font = .zoocFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        return label
    }()
    
    private let deliveryFeeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocFont(font: .medium, size: 16)
        label.textColor = .zoocGray2
        label.textAlignment = .right
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "총 결제 금액"
        label.font = .zoocFont(font: .semiBold, size: 16)
        label.textColor = .zoocGray3
        return label
    }()
    
    private let totalPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .zoocFont(font: .semiBold, size: 16)
        label.textColor = .zoocMainGreen
        return label
    }()
    
    private let payButton: ZoocGradientButton = {
        let button = ZoocGradientButton()
        button.setTitle("\(0.priceText) 결제하기", for: .normal)
        return button
    }()
    
    //MARK: - Life Cycle
    
//    init(selectedProduct: [SelectedProductOption]) {
//        self.selectedProductData = selectedProduct
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        setDelegate()
        updateUI()
        requestDeliveryFee()
        requestCartedProducts()
        dismissKeyboardWhenTappedAround()
    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        view.backgroundColor = .zoocBackgroundGreen
        
    }
    
    private func hierarchy() {
        view.addSubviews(backButton,
                         titleLabel,
                         collectionView,
                         bottomView)
        
        bottomView.addSubviews(lineView,
                               paymentInformationLabel,
                               productsPriceLabel,
                               productsPriceValueLabel,
                               deliveryFeeLabel,
                               deliveryFeeValueLabel,
                               totalPriceLabel,
                               totalPriceValueLabel,
                               payButton)
    }
    
    private func layout() {
        
        //root View
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        // bottom View
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        paymentInformationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        productsPriceLabel.snp.makeConstraints {
            $0.top.equalTo(paymentInformationLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(30)
        }
        
        productsPriceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(productsPriceLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        deliveryFeeLabel.snp.makeConstraints {
            $0.top.equalTo(productsPriceLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
        }
        
        deliveryFeeValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(deliveryFeeLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(30)
        }
        
        totalPriceValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(totalPriceLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        payButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(37)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
    }
    
    
    private func setDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func updateUI() {
        let productsTotalPrice = cartedProducts.reduce(0) { $0 + $1.productsPrice }
        let totalPrice = deliveryFee + productsTotalPrice
        
        productsPriceValueLabel.text = productsTotalPrice.priceText
        
        if cartedProducts.isEmpty {
            deliveryFeeValueLabel.text = 0.priceText
            totalPriceValueLabel.text = 0.priceText
            payButton.isEnabled = false
            payButton.setTitle("주문 상품을 추가해주세요.", for: .normal)
        } else {
            deliveryFeeValueLabel.text = deliveryFee.priceText
            totalPriceValueLabel.text = totalPrice.priceText
            payButton.isEnabled = true
            payButton.setTitle("\(totalPrice.priceText) 결제하기", for: .normal)
        }
        
        totalPriceValueLabel.setAttributeLabel(
            targetString: ["원"],
            color: .zoocGray3,
            font: .zoocBody3,
            spacing: 0
        )
    }
    
    private func requestCartedProducts() {
        cartedProducts = RealmService().getCartedProducts()
    }
    
    //MARK: - Action Method
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func orderButtonDidTap() {
//        let orderVC = OrderViewController()
//        navigationController?.pushViewController(orderVC, animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource

extension ShopCartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCartCollectionViewCell.reuseCellIdentifier,
                                                      for: indexPath) as! ShopCartCollectionViewCell
        cell.dataBind(indexPath: indexPath, selectedOption: cartedProducts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ShopCartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 60
        let height: CGFloat = 90
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

//MARK: - 구역

extension ShopCartViewController: ShopCartCollectionViewCellDelegate {
    func adjustAmountButtonDidTap(row: Int, isPlus: Bool) {
        let optionID = cartedProducts[row].optionID
        do {
            try RealmService().updateCartedProductPieces(optionID: optionID, isPlus: isPlus)
        } catch  {
            guard let error =  error as? AmountError else { return }
            showToast(error.message, type: .bad)
        }
        
        cartedProducts = RealmService().getCartedProducts()
    }
    
    func xButtonDidTap(row: Int) {
        let zoocAlertVC = ZoocAlertViewController(.deleteProduct)
        zoocAlertVC.delegate = self
        zoocAlertVC.dataBind(row)
        present(zoocAlertVC, animated: false)
        
    }
    
}

extension ShopCartViewController: ZoocAlertViewControllerDelegate {
    
    internal func keepButtonDidTap(_ data: Any?) {
        guard let row = data as? Int else { return }
        let product = cartedProducts[row]
        RealmService().deleteCartedProduct(product)
        cartedProducts.remove(at: row)
    }
}


//MARK: - FirebaseRemoteConfig

extension ShopCartViewController {
    private func requestDeliveryFee() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings =  RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { [weak self] status, error in
            
            if status == .success {
                remoteConfig.activate() { [weak self] changed, error in
                    DispatchQueue.main.async {
                        self?.deliveryFee = Int(truncating: remoteConfig["deliveryFee"].numberValue)
                    }
                }
            } else {
                return
            }
        }
    }

}
