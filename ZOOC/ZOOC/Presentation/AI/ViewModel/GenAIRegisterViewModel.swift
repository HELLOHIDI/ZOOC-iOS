//
//  GentAIRegisterViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import Kingfisher

protocol GenAIRegisterViewModelInput {
    func nameTextFieldDidChangeEvent(_ text: String)
    func registerPetButtonDidTap()
    func deleteButtonDidTap()
    func registerPetProfileImageEvent(_ image: UIImage)
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool
}

protocol GenAIRegisterViewModelOutput {
    var ableToEditPetProfile: Observable<Bool> { get }
    var textFieldState: Observable<BaseTextFieldState> { get }
    var registerCompletedOutput: Observable<Bool?> { get }
    var registerPetProfileDataOutput: Observable<MyRegisterPetRequest> { get }
}

typealias GenAIRegisterViewModel = GenAIRegisterViewModelInput & GenAIRegisterViewModelOutput

final class DefaultGenAIRegisterViewModel: GenAIRegisterViewModel {
    
    let repository: GenAIPetRepository
    
    var ableToEditPetProfile: Observable<Bool> = Observable(false)
    var textFieldState: Observable<BaseTextFieldState> = Observable(.isEmpty)
    var registerCompletedOutput: Observable<Bool?> = Observable(nil)
    var registerPetProfileDataOutput: Observable<MyRegisterPetRequest> = Observable(MyRegisterPetRequest())
    
    
    init(repository: GenAIPetRepository) {
        self.repository = repository
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.registerPetProfileDataOutput.value.name = text
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...3:
            textFieldState = .isWritten
            ableToEditPetProfile.value = true
        case 4...:
            textFieldState = .isFull
            ableToEditPetProfile.value = true
        default:
            textFieldState = .isEmpty
            ableToEditPetProfile.value = false
        }
        self.textFieldState.value = textFieldState
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool {
        let limit = type.limit
        return registerPetProfileDataOutput.value.name.count >= limit
    }
    
    func registerPetButtonDidTap() {
        registerPet()
    }
    
    func deleteButtonDidTap() {
        self.registerPetProfileDataOutput.value.photo = Image.defaultProfile
    }
    
    func registerPetProfileImageEvent(_ image: UIImage) {
        self.registerPetProfileDataOutput.value.photo = image
    }
}

extension DefaultGenAIRegisterViewModel {
    func registerPet() {
        repository.registerPet(request: registerPetProfileDataOutput.value) { result in
            switch result {
            case .success(let data):
                self.registerCompletedOutput.value = true
                guard let result = data as? MyRegisterPetResult else { return }
                NotificationCenter.default.post(
                    name: .petSelected,
                    object: result.id
                )
            default:
                self.registerCompletedOutput.value = false
            }
        }
    }
}
