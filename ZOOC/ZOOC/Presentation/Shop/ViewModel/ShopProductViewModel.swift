//
//  ShopProductViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/30.
//

import Foundation

import RxCocoa
import RxSwift

final class ShopProductViewModel {
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let cartButtonDidTap: Observable<[SelectedProductOption]>
        let orderButtonDidTap: Observable<[SelectedProductOption]>
    }
    
    struct Output {
        let productData = PublishRelay<ProductDetailResult>()
        let showToast = PublishRelay<ShopToastCase>()
        let pushToOrderVC = PublishRelay<[OrderProduct]>()
    }
    
    //MARK: - Properties
    
    private let model: ShopProductModel
    var productData: ProductDetailResult?
    
    //MARK: - Life Cycle
    
    init(model: ShopProductModel) {
        self.model = model
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
                    
                    Task {
                        await DefaultRealmService.shared.setCartedProduct(cartedProduct)
                    }
                        
                }
                output.showToast.accept(.cartedCompleted)
            })
            .disposed(by: disposeBag)
        
        input.orderButtonDidTap
            .subscribe(with: self, onNext: { owner, selectedProductOptions in
                
                guard let productData = owner.productData else { return }
                
                var orderProducts: [OrderProduct] = []
                selectedProductOptions.forEach {
                    orderProducts.append(OrderProduct(petID: owner.model.petID,
                                                      product: productData,
                                                      selectedProductOption: $0))
                }
                
                output.pushToOrderVC.accept(orderProducts)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension ShopProductViewModel {
    
    private func requestDetailProductAPI(id: Int, output: Output) {
        ShopAPI.shared.getProduct(productID: id) { result in
            switch result {
            case .success(let data):
                guard let data = data as? ProductDetailResult else { return }
                output.productData.accept(data)
                self.productData = data
            case .requestErr(let error):
                output.showToast.accept(.serverError(message: error))
            default:
                output.showToast.accept(.serverError(message: "서버 오류가 발생했습니다."))
            }
            
        }
    }
}
