//
//  GenAIChoosePetModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

protocol GenAIChoosePetModelInput {
    func viewWillAppearEvent()
    func petButtonDidTapEvent(at index: Int)
    func selectButtonDidTap()
    func deselectAllPet()
}

protocol GenAIChoosePetModelOutput {
    var petList: Observable<[RecordRegisterModel]> { get }
    var ableToChoosePet: Observable<Bool> { get }
    var petId: Observable<Int?> { get }
    var hasDataset: Observable<Bool?> { get }
    var isUploadedImage: Observable<Bool?> { get }
    var isLoading: Observable<Bool?> { get }
}

typealias GenAIChoosePetModel = GenAIChoosePetModelInput & GenAIChoosePetModelOutput

final class DefaultGenAIChoosePetModel: GenAIChoosePetModel {
    
    var petList: Observable<[RecordRegisterModel]> = Observable([])
    var ableToChoosePet: Observable<Bool> = Observable(false)
    var petId: Observable<Int?> = Observable(nil)
    var hasDataset: Observable<Bool?> = Observable(nil)
    var isUploadedImage: Observable<Bool?> = Observable(nil)
    var isLoading: Observable<Bool?> = Observable(nil)
    
    let repository: GenAIPetRepository
    
    init(repository: GenAIPetRepository) {
        self.repository = repository
    }
    
    func viewWillAppearEvent() {
        isLoading.value = true
        repository.getTotalPet() { result in
            self.isLoading.value = false
            switch result {
            case .success(let data):
                guard let result = data as? [PetResult] else { return }
                self.petList.value = []
                result.forEach { self.petList.value.append($0.transform()) }
            default:
                break
            }
        }
    }
    
    func petButtonDidTapEvent(at index: Int) {
        for i in 0..<petList.value.count {
            petList.value[i].isSelected = (i == index)
        }
        ableToChoosePet.value = true
        petId.value = petList.value[index].petID
    }
    
    
    func deselectAllPet() {
        for i in 0..<petList.value.count {
            petList.value[i].isSelected = false
        }
    }
    
    func selectButtonDidTap() {
        isLoading.value = true
        guard let petId = petId.value else { return }
        repository.getPetDataset(petId: String(petId)) { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let data):
                self?.hasDataset.value = true
                guard let result = data as? GenAIPetDatasetsResult else { return }
                if !result.datasetImages.isEmpty { self?.isUploadedImage.value = true }
                else { self?.isUploadedImage.value = false }
            default:
                self?.isUploadedImage.value = false
                self?.hasDataset.value = false
            }
        }
    }
}
