//
//  DefaultGenAIRegisterPetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/11.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultGenAIRegisterPetUseCase: GenAIRegisterPetUseCase {
    private let repository: GenAIPetRepository
    private let disposeBag = DisposeBag()
    
    init(repository: GenAIPetRepository) {
        self.repository = repository
    }
    
    var petId = BehaviorRelay<Int?>(value: nil)
    var name = BehaviorRelay<String>(value: "")
    var photo = BehaviorRelay<UIImage?>(value: nil)
    var canRegisterPet = BehaviorRelay<Bool>(value: false)
    var isRegistedPet = BehaviorRelay<Bool>(value: false)
    var isTextCountExceeded = BehaviorRelay<Bool>(value: false)
    var textFieldState = BehaviorRelay<BaseTextFieldState>(value: .isEmpty)
    
    func deleteProfileImage() {
        self.photo.accept(Image.defaultProfile)
    }
    func registerProfileImage(_ image: UIImage) {
        self.photo.accept(image)
    }
    
    func registerPet() {
        let pet = MyRegisterPetRequest(name: name.value, photo: photo.value)
        repository.registerPet(request: pet) { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data as? MyRegisterPetResult else { return }
                self?.petId.accept(result.id)
                self?.canRegisterPet.accept(true)
            default:
                self?.canRegisterPet.accept(false)
            }
        }
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) {
        let limit = type.limit
        self.isTextCountExceeded.accept(name.value.count >= limit)
    }
    
    func nameTextFieldDidChangeEvent(_ text: String?) {
        guard let name = text else { return }
        self.name.accept(name)
        switch name.count {
        case 1...3:
            textFieldState.accept(.isWritten)
            canRegisterPet.accept(true)
        case 4...:
            textFieldState.accept(.isFull)
            canRegisterPet.accept(true)
        default:
            textFieldState.accept(.isEmpty)
            canRegisterPet.accept(false)
        }
    }
}
