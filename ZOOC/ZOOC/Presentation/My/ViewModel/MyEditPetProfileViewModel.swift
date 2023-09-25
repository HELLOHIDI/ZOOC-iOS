//
//  MyEditPetProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

import Kingfisher

protocol MyEditPetProfileModelInput {
    func nameTextFieldDidChangeEvent(_ text: String)
    func editCompleteButtonDidTap()
    func deleteButtonDidTap()
    func editPetProfileImageEvent(_ image: UIImage)
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool
}

protocol MyEditPetProfileModelOutput {
    var ableToEditPetProfile: ObservablePattern<Bool> { get }
    var textFieldState: ObservablePattern<BaseTextFieldState> { get }
    var editCompletedOutput: ObservablePattern<Bool?> { get }
    var editPetProfileDataOutput: ObservablePattern<EditPetProfileRequest> { get }
    
}

typealias MyEditPetProfileViewModel = MyEditPetProfileModelInput & MyEditPetProfileModelOutput

final class DefaultMyEditPetProfileViewModel: MyEditPetProfileViewModel {
    let id: Int
    let repository: MyEditPetProfileRepository
    
    var ableToEditPetProfile: ObservablePattern<Bool> = ObservablePattern(false)
    var textFieldState: ObservablePattern<BaseTextFieldState> = ObservablePattern(.isEmpty)
    var editCompletedOutput: ObservablePattern<Bool?> = ObservablePattern(nil)
    var editPetProfileDataOutput: ObservablePattern<EditPetProfileRequest> = ObservablePattern(EditPetProfileRequest())
    
    init(id: Int,
        editPetProfileRequest: EditPetProfileRequest,
        repository: MyEditPetProfileRepository) {
        self.id = id
        self.editPetProfileDataOutput.value = editPetProfileRequest
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
        patchPetProfile()
    }
    
    func deleteButtonDidTap() {
        self.editPetProfileDataOutput.value.file = nil
        self.editPetProfileDataOutput.value.photo = false
        ableToProfile()
    }
    
    func editPetProfileImageEvent(_ image: UIImage) {
        self.editPetProfileDataOutput.value.file = image
        self.editPetProfileDataOutput.value.photo = true
        ableToProfile()
    }
}

extension DefaultMyEditPetProfileViewModel {
    func patchPetProfile() {
        repository.patchPetProfile(request: editPetProfileDataOutput.value, id: id) { result in
            switch result {
            case .success(_):
                self.editCompletedOutput.value = true
                NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
                NotificationCenter.default.post(name: .myPageUpdate, object: nil)
            default:
                self.editCompletedOutput.value = false
            }
        }
    }
    
    func ableToProfile() {
        ableToEditPetProfile.value = self.editPetProfileDataOutput.value.nickName.count != 0
    }
}
