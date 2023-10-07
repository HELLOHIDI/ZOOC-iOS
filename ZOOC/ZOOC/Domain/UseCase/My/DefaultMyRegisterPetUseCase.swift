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
    
    var petMemberData = BehaviorRelay<[PetResult]>(value: [])
    var ableToRegisterPets = BehaviorRelay<Bool?>(value: nil)
    var isRegistered = PublishRelay<Bool>()
    var registerPetData = BehaviorRelay<[MyPetRegisterModel]>(value: [])
    var addButtonIsHidden = BehaviorRelay<Bool>(value: false)
    var deleteButtonIsHidden = BehaviorRelay<Bool>(value: false)
    
    func requestPetData() {
        repository.requestMyPageAPI(completion: { result in
            switch result {
            case .success(let data):
                guard let result = data as? MyResult else { return }
                self.petMemberData.accept(result.pet)
                self.checkAddButtonState()
            default:
                break
            }
        })
    }
    
    func registerPet() {
        var names: [String] = []
        var photos: [Data] = []
        var isPhotos: [Bool] = []
        var isPhoto: Bool = true
        
        for pet in self.registerPetData.value {
            isPhoto = pet.image != Image.cameraCircle
            guard let photo = pet.image?.jpegData(compressionQuality: 1.0) else {
                isPhoto = false
                return
            }
            names.append(pet.name)
            photos.append(photo)
            isPhotos.append(isPhoto)
        }
        
        repository.registerPets(
            request: MyRegisterPetsRequest(
                petNames: names,
                files: photos,
                isPetPhotos: isPhotos
            ), completion: { result in
                switch result {
                case .success(_):
                    self.isRegistered.accept(true)
                default:
                    self.isRegistered.accept(false)
                }
            })
    }
    
    func addPet() {
        registerPetData.add(
            element: MyPetRegisterModel(
                name: "",
                image: Image.cameraCircle
            )
        )
        checkAddButtonState()
        checkDeleteButtonState()
        checkRegisterPets()
    }
    
    func deletePet(_ index: Int) {
        registerPetData.remove(index: index)
        checkAddButtonState()
        checkDeleteButtonState()
        checkRegisterPets()
    }
    
    func deleteProfileImage(_ index: Int) {
        var updateRegisterPetData = registerPetData.value
        updateRegisterPetData[index].image = nil
        self.registerPetData.accept(updateRegisterPetData)
        checkRegisterPets()
    }
    
    func selectProfileImage(_ data: (UIImage, Int)) {
        var updateRegisterPetData = registerPetData.value
        updateRegisterPetData[data.1].image = data.0
        self.registerPetData.accept(updateRegisterPetData)
        checkRegisterPets()
    }
    
    func updatePetName(_ data: (String, Int)) {
        var updateRegisterPetData = registerPetData.value
        updateRegisterPetData[data.1].name = data.0
        self.registerPetData.accept(updateRegisterPetData)
        checkRegisterPets()
    }
}



extension DefaultMyRegisterPetUseCase {
    func checkAddButtonState() {
        addButtonIsHidden.accept(petMemberData.value.count + registerPetData.value.count == 4)
    }
    
    func checkDeleteButtonState() {
        deleteButtonIsHidden.accept(registerPetData.value.count == 1)
    }
    
    func checkRegisterPets() {
        for pet in registerPetData.value {
            if pet.name.count == 0 {
                ableToRegisterPets.accept(false)
                return
            }
        }
        ableToRegisterPets.accept(true)
    }
}

