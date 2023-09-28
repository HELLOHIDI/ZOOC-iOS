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
    var isRegistered = BehaviorRelay<Bool?>(value: nil)
    var registerPetData = BehaviorRelay<[PetResult]>(value: [])
    
    func requestPetData() {
        repository.requestMyPageAPI(completion: { result in
            switch result {
            case .success(let data):
                guard let result = data as? MyResult else { return }
                self.petMemberData.accept(result.pet)
            default:
                break
            }
        })
    }
    
    func registerPet() {
//        repository.registerPets(request: <#T##MyRegisterPetsRequest#>, completion: <#T##(NetworkResult<Any>) -> Void#>)
    }
}
//    @objc private func registerPetButtonDidTap() {
//        var names: [String] = []
//        var photos: [Data] = []
//        var isPhotos: [Bool] = []
//        var isPhoto: Bool = true
//
//        for pet in self.myPetRegisterViewModel.petList {
//            isPhoto = pet.image != Image.cameraCircle
//            guard let photo = pet.image.jpegData(compressionQuality: 1.0) else {
//                isPhoto = false
//                return
//            }
//            names.append(pet.name)
//            photos.append(photo)
//            isPhotos.append(isPhoto)
//        }
//
//        MyAPI.shared.registerPets(
//            request: MyRegisterPetsRequest(petNames: names, files: photos, isPetPhotos: isPhotos)
//        ) { result in
//            self.validateResult(result)
//            NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
//            NotificationCenter.default.post(name: .myPageUpdate, object: nil)
//            if let presentingViewController = self.presentingViewController {
//                // presented로 표시된 경우
//                presentingViewController.dismiss(animated: true)
//            } else if let navigationController = self.navigationController {
//                // pushed로 표시된 경우
//                navigationController.popViewController(animated: true)
//            }
//        }
//
//    }
