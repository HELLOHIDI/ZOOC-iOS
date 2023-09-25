//
//  OnboardingChooseRoleViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/09.
//

import UIKit

import Kingfisher

protocol OnboardingChooseRoleViewModelInput {
    func nameTextFieldDidChangeEvent(_ text: String)
    func editCompleteButtonDidTap()
}

protocol OnboardingChooseRoleViewModelOutput {
    var ableToEditProfile: ObservablePattern<Bool> { get }
    var textFieldState: ObservablePattern<BaseTextFieldState> { get }
    var editCompletedOutput: ObservablePattern<Bool?> { get }
}

protocol OnboardingChooseRoleNetworkHandlerProtocol {
    func patchMyProfile()
}

final class OnboardingChooseRoleViewModel: OnboardingChooseRoleViewModelInput, OnboardingChooseRoleViewModelOutput {
    
    var ableToEditProfile: ObservablePattern<Bool> = ObservablePattern(false)
    var textFieldState: ObservablePattern<BaseTextFieldState> = ObservablePattern(.isEmpty)
    var editCompletedOutput: ObservablePattern<Bool?> = ObservablePattern(nil)
    var editProfileDataOutput: ObservablePattern<EditProfileRequest> = ObservablePattern(EditProfileRequest())
    
    
    init(editProfileData: EditProfileRequest) {
        self.editProfileDataOutput.value = editProfileData
    }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.editProfileDataOutput.value.nickName = text
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...9:
            textFieldState = .isWritten
            ableToEditProfile.value = true
        case 10...:
            textFieldState = .isFull
            ableToEditProfile.value = true
            
        default:
            textFieldState = .isEmpty
            ableToEditProfile.value = false
        }
        
        self.textFieldState.value = textFieldState
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool {
        let limit = type.limit
        return editProfileDataOutput.value.nickName.count >= limit
    }
    
    
    func editCompleteButtonDidTap() {
        patchMyProfile()
    }
}

extension OnboardingChooseRoleViewModel: OnboardingChooseRoleNetworkHandlerProtocol {
    func patchMyProfile() {
        MyAPI.shared.patchMyProfile(requset: editProfileDataOutput.value) { result in
            switch result {
            case .success(_):
                self.editCompletedOutput.value = true
            default:
                self.editCompletedOutput.value = false
            }
        }
    }
}
