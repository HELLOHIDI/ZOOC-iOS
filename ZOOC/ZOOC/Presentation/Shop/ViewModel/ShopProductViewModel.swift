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
        
    }
    
    struct Output {
        
    }
    
    //MARK: - Properties
    
    private let petID: Int
    
    //MARK: - Life Cycle
    
    init(petID: Int) {
        self.petID = petID
    }

    //MARK: - Public Method
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }

    
}
