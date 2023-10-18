//
//  DefaultShopChoosePetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/16.
//

import Foundation

import RxSwift
import RxCocoa

final class DefaultShopChoosePetUseCase: ShopChoosePetUseCase {
    
    private let repository: GenAIPetRepository
    private let disposeBag = DisposeBag()
    
    init(repository: GenAIPetRepository) {
        self.repository = repository
    }
    
    var petList = BehaviorRelay<[RecordRegisterModel]>(value: [])
    var petId = BehaviorRelay<Int?>(value: nil)
    var canRegisterPet = BehaviorRelay<Bool>(value: false)
    var canPushNextView = BehaviorRelay<Bool>(value: false)
    
    
    func selectPet(at index: Int) {
        print(#function)
        let updatedPetList = petList.value.map { pet in
            var updatedPet = pet
            updatedPet.isSelected = pet.petID == petList.value[index].petID
            return updatedPet
        }
        petList.accept(updatedPetList)
        canRegisterPet.accept(true)
        petId.accept(petList.value[index].petID)
    }
    
    func getTotalPet() {
        repository.getTotalPet() { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? [PetResult] else { return }
                var updatedList: [RecordRegisterModel] = []
                result.forEach { updatedList.append($0.transform()) }
                self?.petList.accept(updatedList)
            default:
                break
            }
        }
    }
    
    func pushNextView() {
        canPushNextView.accept(canRegisterPet.value)
    }
}

