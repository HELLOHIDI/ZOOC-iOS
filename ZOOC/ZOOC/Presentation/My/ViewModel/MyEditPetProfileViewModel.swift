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
}

protocol MyEditPetProfileModelOutput {
    var ableToEditPetProfile: Observable<Bool> { get }
    var textFieldState: Observable<BaseTextFieldState> { get }
    var editCompletedOutput: Observable<Bool?> { get }
    var editPetProfileDataOutput: Observable<EditPetProfileRequest> { get }
}

protocol MyEditPetNetworkHandlerProtocol {
    func patchPetProfile()
}

final class MyEditPetProfileViewModel: MyEditPetProfileModelInput, MyEditPetProfileModelOutput {
    var ableToEditPetProfile: Observable<Bool> = Observable(false)
    var textFieldState: Observable<BaseTextFieldState> = Observable(.isEmpty)
    var editCompletedOutput: Observable<Bool?> = Observable(nil)
    var editPetProfileDataOutput: Observable<EditPetProfileRequest> = Observable(EditPetProfileRequest())
    
    var id: Int
    
    init(id: Int, editPetProfileRequest: EditPetProfileRequest) {
        self.id = id
        self.editPetProfileDataOutput.value = editPetProfileRequest
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        print(#function)
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
    }
    
    func editPetProfileImageEvent(_ image: UIImage) {
        self.editPetProfileDataOutput.value.file = image
        self.editPetProfileDataOutput.value.photo = true
    }
}

extension MyEditPetProfileViewModel: MyEditPetNetworkHandlerProtocol {
    func patchPetProfile() {
        MyAPI.shared.patchPetProfile(requset: editPetProfileDataOutput.value, id: id) { result in
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
}
