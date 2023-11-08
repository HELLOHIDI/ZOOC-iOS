//
//  DefaultMyRegisterPetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/29.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyRegisterPetUseCase: MyRegisterPetUseCase {
    
    private let repository: MyRepository
    private let disposeBag = DisposeBag()
    
    init(repository: MyRepository) {
        self.repository = repository
    }
    
    var ableToRegisterPet = BehaviorRelay<Bool?>(value: nil)
    var isRegistered = PublishRelay<Bool>()
    var petName = BehaviorRelay<String>(value: "")
    var petBreed = BehaviorRelay<String>(value: "")
    
    
    func registerPet() {
    }
    
    func updatePetName(_ name: String) {
        petName.accept(name)
    }
    
    func updatePetBreed(_ breed: String) {
        petBreed.accept(breed)
    }
}


