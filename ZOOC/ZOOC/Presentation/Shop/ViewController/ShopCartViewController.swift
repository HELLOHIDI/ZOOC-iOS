//
//  ShopCartViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/05.
//

import UIKit

import FirebaseRemoteConfig
import RxCocoa
import RxSwift

final class ShopCartViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private var deliveryFee: Int = 4000 {
        didSet {
            updateUI()
        }
    }
    
    private var cartedProducts: [CartedProduct] = [] {
        didSet {
            rootView.collectionView.reloadData()
            updateUI()
        }
    }
    
    //MARK: - UI Components
    
    private let rootView = ShopCartView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setDelegate()
        updateUI()
        
        requestDeliveryFee()
        requestCartedProducts()
        dismissKeyboardWhenTappedAround()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.payButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                var orderProducts: [OrderProduct] = []
                owner.cartedProducts.forEach {
                    orderProducts.append(OrderProduct(cartedProduct: $0))
                }
                let orderVC = OrderViewController(orderProducts)
                owner.navigationController?.pushViewController(orderVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.emptyCartButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setDelegate(){
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func updateUI() {
        
        rootView.emptyCartView.isHidden = !cartedProducts.isEmpty
        rootView.payButton.isEnabled = !cartedProducts.isEmpty
        
        let productsTotalPrice = cartedProducts.reduce(0) { $0 + $1.productsPrice }
        let totalPrice = deliveryFee + productsTotalPrice
        
        rootView.productsPriceValueLabel.text = productsTotalPrice.priceText
        
        rootView.deliveryFeeValueLabel.text = deliveryFee.priceText
        rootView.totalPriceValueLabel.text = totalPrice.priceText
        rootView.payButton.setTitle("\(totalPrice.priceText) 결제하기", for: .normal)
        
        rootView.totalPriceValueLabel.setAttributeLabel(
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
