//
//  DefaultRecordSelectPetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/03.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultRecordSelectPetUseCase: RecordSelectPetUseCase {
    
    private let disposeBag = DisposeBag()
    private let repository: RecordRepository
    
    init(photo: UIImage, content: String, repository: RecordRepository) {
        self.photo.accept(photo)
        self.content.accept(content)
        self.repository = repository
    }
    
    var petList = BehaviorRelay<[RecordRegisterModel]>(value: [])
    var ableToRecord = BehaviorRelay<Bool?>(value: nil)
    var isRegistered = BehaviorRelay<Bool?>(value: nil)
    var photo = BehaviorRelay<UIImage?>(value: nil)
    var content = BehaviorRelay<String?>(value: nil)
    
    func selectPet(at index: Int) {
        var updatedPetList = petList.value
        updatedPetList[index].isSelected.toggle()
        petList.accept(updatedPetList)
        ableToRecord.accept(true)
    }
    
    func getTotalPet() {
        repository.getTotalPet(familyID: UserDefaultsManager.familyID) { [weak self] result in
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
    
    func postRecord() {
        guard let photo = photo.value else { return }
        let petIdList: [Int] =
        petList.value.filter { $0.isSelected == true }.map { $0.petID }
        
        repository.postRecord(
            familyID: UserDefaultsManager.familyID,
            photo: photo,
            content: content.value,
            pets: petIdList) { [weak self] result in
                switch result {
                case .success(_):
                    self?.isRegistered.accept(true)
                default:
                    self?.isRegistered.accept(false)
                }
            }
    }
}
