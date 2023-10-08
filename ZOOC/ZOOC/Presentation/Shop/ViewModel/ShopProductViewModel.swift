//
//  ShopProductViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import Foundation

import FirebaseAnalytics
import RxCocoa
import RxSwift

final class ShopProductViewModel {
    
    private let service: RealmService
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let cartButtonDidTap: Observable<[SelectedProductOption]>
        let orderButtonDidTap: Observable<[SelectedProductOption]>
    }
    
    struct Output {
        let productDetailData = PublishRelay<ProductDetailResult>()
        let productImagesData = PublishRelay<[String]>()
        let showToast = PublishRelay<ShopToastCase>()
        let pushToOrderVC = PublishRelay<[OrderProduct]>()
    }
    
    //MARK: - Properties
    
    private let model: ShopProductModel
    var productData: ProductDetailResult?
    
    //MARK: - Life Cycle
    
    init(model: ShopProductModel, service: RealmService) {
        self.model = model
        self.service = service
    }

    //MARK: - Public Method
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(with: self, onNext: { owner, _ in
                owner.requestDetailProductAPI(id: owner.model.productID,
                                              output: output)
            })
            .disposed(by: disposeBag)
        
        input.cartButtonDidTap
            .subscribe(with: self, onNext: { owner, selectedProductOptions in
                
                guard let productData = owner.productData else { return }
                
                
                selectedProductOptions.forEach {
                    let cartedProduct = CartedProduct(petID: owner.model.petID,
                                                      product: productData,
                                                      selectedProduct: $0)
                    owner.setCartedProduct(cartedProduct)
                    
                    Analytics.logEvent(AnalyticsEventAddToCart,
                                       parameters: [ AnalyticsParameterItemID: cartedProduct.productID,
                                                   AnalyticsParameterItemName: cartedProduct.name,
                                               AnalyticsParameterItemVariant: cartedProduct.option,
                                                      AnalyticsParameterPrice: cartedProduct.price,
                                                     "petID": cartedProduct.petID])
                    
                }
                output.showToast.accept(.cartedCompleted)
            })
            .disposed(by: disposeBag)
        
        input.orderButtonDidTap
            .subscribe(with: self, onNext: { owner, selectedProductOptions in
                
                guard let productData = owner.productData else { return }
                
                let orderProducts = selectedProductOptions.map { OrderProduct(petID: owner.model.petID,
                                                                              product: productData,
                                                                              selectedProductOption: $0)}
                output.pushToOrderVC.accept(orderProducts)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}

//MARK: - RealmService

extension ShopProductViewModel {
    private func setCartedProduct(_ data: CartedProduct) {
        Task {
            await self.service.setCartedProduct(data)
        }
    }
}


//MARK: - Zooc Service

extension ShopProductViewModel {
    
    private func requestDetailProductAPI(id: Int, output: Output) {
        ShopAPI.shared.getProduct(productID: id) { result in
            switch result {
            case .success(let data):
                guard let data = data as? ProductDetailResult else { return }
                output.productDetailData.accept(data)
                output.productImagesData.accept(data.images)
                self.productData = data
                
                
                Analytics.logEvent(AnalyticsEventViewItem,
                                   parameters: [ AnalyticsParameterItemID: data.id,
                                               AnalyticsParameterItemName: data.name,
                                           AnalyticsParameterItemCategory: data.type,
                                                  AnalyticsParameterPrice: data.price])
                
            case .requestErr(let error):
                output.showToast.accept(.custom(message: error))
            default:
                output.showToast.accept(.custom(message: "서버 오류가 발생했습니다."))
            }
            
        }
    }
}
