//
//  ShopViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/29.
//

import Foundation

import RxSwift
import RxCocoa

final class ShopViewModel {
    
    //MARK: - Input & Output
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let productCellDidSelectEvent: Observable<ProductResult>
    }
    
    struct Output {
        let productData = PublishRelay<[ProductResult]>()
        let pushShopProductVC = PublishRelay<ShopProductModel>()
        let showCommingSoonToast = PublishRelay<Void>()
    }
    
    //MARK: - Properties
    
    private var petID: Int
    private var productData: [ProductResult] = []
    
    //MARK: - Life Cycle
    
    init(petID: Int) {
        self.petID = petID
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(with: self) { owner, _ in
                owner.requestProductsAPI(output: output)
            }
            .disposed(by: disposeBag)
        
        input.productCellDidSelectEvent
            .subscribe(with: self, onNext: { owner, data in
                guard data != ProductResult() else {
                    output.showCommingSoonToast.accept(())
                    return
                }
                
                let model = ShopProductModel(petID: owner.petID,
                                             productID: data.id)
                output.pushShopProductVC.accept(model)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension ShopViewModel {
    
    private func requestProductsAPI(output: Output) {
        ShopAPI.shared.getTotalProducts { result in
            switch result {
            case .success(let data):
                guard var data = data as? [ProductResult] else {
                    return
                }
                data.append(.init()) // 커밍쑨 담당 데이터 추가
                output.productData.accept(data)
            default:
                return
            }
        }
        
    }
}
