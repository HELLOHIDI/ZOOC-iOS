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
        let productData = BehaviorRelay<[ProductResult]>(value: [])
        let pushShopProductVC = BehaviorRelay<ShopProductModel>(value: .init())        
    }
    
    //MARK: - Properties
    
    private var petID: Int
    
    //MARK: - Life Cycle
    
    init(petID: Int) {
        self.petID = petID
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        bindOutput(output: output, disposeBag: disposeBag)
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        return
    }
    
}
