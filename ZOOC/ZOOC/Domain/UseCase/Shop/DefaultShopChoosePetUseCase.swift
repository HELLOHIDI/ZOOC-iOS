//
//  DefaultShopChoosePetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/16.
//

import Foundation

import RxSwift
import RxCocoa

enum DatasetStatus {
    case notStarted
    case inProgress
    case done
}

final class DefaultShopChoosePetUseCase: ShopChoosePetUseCase {
    private let repository: GenAIPetRepository
    private let disposeBag = DisposeBag()
    
    init(repository: GenAIPetRepository) {
        self.repository = repository
    }
    
    var petList = BehaviorRelay<[RecordRegisterModel]>(value: [])
    var petId = BehaviorRelay<Int?>(value: nil)
    var canRegisterPet = BehaviorRelay<Bool>(value: false)
    var datasetStatus = BehaviorRelay<DatasetStatus?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    func selectPet(at index: Int) {
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
    
    func checkDatasetValid() {
        isLoading.accept(true)
        guard let petId = petId.value else { return }
        DispatchQueue.global().async {
            self.repository.getPetDataset(petId: String(petId)) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let result = data as? GenAIPetDatasetsResult else { return }
                    if result.datasetImages.isEmpty {
                        self?.datasetStatus.accept(.inProgress)
                    } else {
                        self?.datasetStatus.accept(.done)
                    }
                case .requestErr(_):
                    self?.datasetStatus.accept(.notStarted)
                default:
                    break
                }
                self?.isLoading.accept(false)
            }
        }
    }
    
    func initPetList() {
        let updatedPetList = petList.value.map { pet in
            var updatedPet = pet
            updatedPet.isSelected = false
            return updatedPet
        }
        petList.accept(updatedPetList)
        canRegisterPet.accept(false)
        petId.accept(nil)
    }
}

