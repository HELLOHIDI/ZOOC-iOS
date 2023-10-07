//
//  ShopCartViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/01.
//

import Foundation

import FirebaseRemoteConfig
import RxCocoa
import RxSwift

final class ShopCartViewModel {
    
    private let service: RealmService
    
    //MARK: - Input & Output
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let orderButtonDidTapEvent: Observable<Void>
        let cellAdjustAmountButtonDidTapEvent: Observable<(Int,Bool)>
        let cellDeleteButtonDidTapEvent: Observable<Int>
    }
    
    struct Output {
        let deliveryFee = BehaviorRelay<Int>(value: 3000)
        let cartedProductsData = BehaviorRelay<[CartedProduct]>(value: [])
        let pushOrderVC = PublishRelay<[OrderProduct]>()
        let showToast = PublishRelay<ShopToastCase>()
    }
    
    //MARK: - Properties
    
    private var cartedProducts: [CartedProduct] = []
    
    //MARK: - Life Cycle

    init(service: RealmService) {
        self.service = service
    }
    
    //MARK: - Method
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.requestCartedProducts(output: output)
                owner.requestDeliveryFee(output: output)
            })
            .disposed(by: disposeBag)
        
        input.orderButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                let orderProducts = owner.cartedProducts.map { OrderProduct(cartedProduct: $0) }
                output.pushOrderVC.accept(orderProducts)
            })
            .disposed(by: disposeBag)
        
        input.cellAdjustAmountButtonDidTapEvent
            .subscribe(onNext: { [weak self] row, isPlus in
                self?.updateCartedProductAmount(row: row, isPlus: isPlus, output: output)
            })
            .disposed(by: disposeBag)
        
        input.cellDeleteButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, row in
                owner.deleteCartedProduct(row: row, output: output)
            })
            .disposed(by: disposeBag)
        
        return output
    }

}

//MARK: - Realm Service

extension ShopCartViewModel {
    
    
    private func requestCartedProducts(output: Output) {
        Task {
            let data = await service.getCartedProducts()
            output.cartedProductsData.accept(data)
            self.cartedProducts = data
        }
        
    }
    
    private func updateCartedProductAmount(row: Int, isPlus: Bool, output: Output) {
        let optionID = cartedProducts[row].optionID
        Task {
            do {
                try await service.updateCartedProductPieces(optionID: optionID, isPlus: isPlus)
                requestCartedProducts(output: output)
            } catch  {
                guard let error =  error as? AmountError else { return }
                output.showToast.accept(.custom(message: error.message))
            }
        }
        
    }
    
    private func deleteCartedProduct(row: Int, output: Output) {
        let product = cartedProducts[row]
        Task {
            await service.deleteCartedProduct(product)
            requestCartedProducts(output: output)
        }
    }
}


//MARK: - Firebase Service

extension ShopCartViewModel {
    private func requestDeliveryFee(output: Output) {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings =  RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { status, error in
            if status == .success {
                remoteConfig.activate() { changed, error in
                    DispatchQueue.main.async {
                        let fee = Int(truncating: remoteConfig["deliveryFee"].numberValue)
                        output.deliveryFee.accept(fee)
                    }
                }
            } else {
                return
            }
        }
    }

}
