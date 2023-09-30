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
        label.text = "장바구니"
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
    
    private lazy var payButton: ZoocGradientButton = {
        let button = ZoocGradientButton()
        button.setTitle("\(0.priceText) 결제하기", for: .normal)
        button.addTarget(self,
                         action: #selector(orderButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let emptyCartView: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocBackgroundGreen
        view.isHidden = true
        return view
    }()
    
    private let emptyCartImageView: UIImageView = {
        let imageView = UIImageView(image: Image.cartLight)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 담은 상품이 없어요"
        label.font = .zoocHeadLine
        label.textColor = .zoocGray2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyCartButton: ZoocGradientButton = {
        let button = ZoocGradientButton(.order)
        button.setTitle("굿즈 담으러 가기", for: .normal)
        button.addTarget(self,
                         action: #selector(backButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
    
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
    
    //MARK: - Custom Method
    
    
    private func style() {
        view.backgroundColor = .zoocBackgroundGreen
        
    }
    
    private func hierarchy() {
        view.addSubviews(collectionView,
                         bottomView,
                         emptyCartView,
                         backButton,
                         titleLabel)
        
        bottomView.addSubviews(lineView,
                               paymentInformationLabel,
                               productsPriceLabel,
                               productsPriceValueLabel,
                               deliveryFeeLabel,
                               deliveryFeeValueLabel,
                               totalPriceLabel,
                               totalPriceValueLabel,
                               payButton)
        
        emptyCartView.addSubviews(emptyCartImageView,
                                  emptyCartLabel,
                                  emptyCartButton)
    }
    
    private func layout() {
        
        //root View
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
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
        
        
        emptyCartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyCartImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.size.equalTo(95)
        }
        
        emptyCartLabel.snp.makeConstraints {
            $0.top.equalTo(emptyCartImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        emptyCartButton.snp.makeConstraints {
            $0.top.equalTo(emptyCartLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(emptyCartLabel)
            $0.height.equalTo(52)
        }
    }
    
    
    private func setDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func updateUI() {
        
        emptyCartView.isHidden = !cartedProducts.isEmpty
        payButton.isEnabled = !cartedProducts.isEmpty
        
        let productsTotalPrice = cartedProducts.reduce(0) { $0 + $1.productsPrice }
        let totalPrice = deliveryFee + productsTotalPrice
        
        productsPriceValueLabel.text = productsTotalPrice.priceText
        
        deliveryFeeValueLabel.text = deliveryFee.priceText
        totalPriceValueLabel.text = totalPrice.priceText
        payButton.setTitle("\(totalPrice.priceText) 결제하기", for: .normal)
        
        totalPriceValueLabel.setAttributeLabel(
            targetString: ["원"],
            color: .zoocGray3,
            font: .zoocBody3,
            spacing: 0
        )
    }
    
    private func requestCartedProducts() {
        Task {
            cartedProducts = await DefaultRealmService.shared.getCartedProducts()
        }
        
    }
    
    //MARK: - Action Method
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func orderButtonDidTap() {
        var orderProducts: [OrderProduct] = []
        cartedProducts.forEach {
            orderProducts.append(OrderProduct(cartedProduct: $0))
        }
        let orderVC = OrderViewController(orderProducts)
        navigationController?.pushViewController(orderVC, animated: true)
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
            Task {
                do {
                    try await DefaultRealmService.shared.updateCartedProductPieces(optionID: optionID, isPlus: isPlus)
                } catch  {
                    guard let error =  error as? AmountError else { return }
                    showToast(ShopToastCase.serverError(message: error.message))
                }
            }
        
        Task {
            cartedProducts = await DefaultRealmService.shared.getCartedProducts()
        }
        
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
        Task {
            await DefaultRealmService.shared.deleteCartedProduct(product)
            cartedProducts.remove(at: row)
        }
        
        
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
