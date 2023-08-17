//
//  GenAIChoosePetModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

protocol GenAIChoosePetModelInput {
    func viewWillAppearEvent()
    func petSelectedEvent(at index: Int)
}

protocol GenAIChoosePetModelOutput {
    var petList: Observable<[RecordRegisterModel]> { get }
    var ableToChoosePet: Observable<Bool> { get }
}

typealias GenAIChoosePetModel = GenAIChoosePetModelInput & GenAIChoosePetModelOutput

final class DefaultGenAIChoosePetModel: GenAIChoosePetModel {
    var petList: Observable<[RecordRegisterModel]> = Observable([])
    var ableToChoosePet: Observable<Bool> = Observable(false)
    
    let repository: GenAIChoosePetRepository
    
    init(repository: GenAIChoosePetRepository) {
        self.repository = repository
    }
    
    func viewWillAppearEvent() {
        repository.getTotalPet() { result in
            switch result {
            case .success(let data):
                guard let result = data as? [RecordPetResult] else { return }
                self.petList.value = []
                result.forEach { self.petList.value.append($0.transform()) }
            default:
                break
            }
        }
    }
    
    func petSelectedEvent(at index: Int) {
        for i in 0..<petList.value.count {
            petList.value[i].isSelected = (i == index)
        }
        ableToChoosePet.value = true
    }
}
