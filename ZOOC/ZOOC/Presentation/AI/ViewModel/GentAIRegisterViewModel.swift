//
//  GentAIRegisterViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import Kingfisher

protocol GentAIRegisterViewModelInput {
    func nameTextFieldDidChangeEvent(_ text: String)
    func editCompleteButtonDidTap()
    func deleteButtonDidTap()
    func editPetProfileImageEvent(_ image: UIImage)
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool
}

protocol GentAIRegisterViewModelOutput {
    var ableToEditPetProfile: Observable<Bool> { get }
    var textFieldState: Observable<BaseTextFieldState> { get }
    var editCompletedOutput: Observable<Bool?> { get }
    var editPetProfileDataOutput: Observable<EditPetProfileRequest> { get }
}

typealias GentAIRegisterViewModel = GentAIRegisterViewModelInput & GentAIRegisterViewModelOutput

final class DefaultGentAIRegisterViewModel: GentAIRegisterViewModel {
    
    let repository: MyEditPetProfileRepository
    
    var ableToEditPetProfile: Observable<Bool> = Observable(false)
    var textFieldState: Observable<BaseTextFieldState> = Observable(.isEmpty)
    var editCompletedOutput: Observable<Bool?> = Observable(nil)
    var editPetProfileDataOutput: Observable<EditPetProfileRequest> = Observable(EditPetProfileRequest())
    
    
    
    init(repository: MyEditPetProfileRepository) {
        self.repository = repository
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.editPetProfileDataOutput.value.nickName = text
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
        return editPetProfileDataOutput.value.nickName.count >= limit
    }
    
    func editCompleteButtonDidTap() {
//        patchPetProfile()
    }
    
    func deleteButtonDidTap() {
        self.editPetProfileDataOutput.value.file = nil
        self.editPetProfileDataOutput.value.photo = false
    }
    
    func editPetProfileImageEvent(_ image: UIImage) {
        self.editPetProfileDataOutput.value.file = image
        self.editPetProfileDataOutput.value.photo = true
    }
}

