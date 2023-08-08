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
    var textFieldCharacterCount: Observable<Int> { get }
}

final class MyEditPetProfileViewModel: MyEditPetProfileModelInput, MyEditPetProfileModelOutput {
    
    var id: Int
    var name: String
    var photo: UIImage?
    var hasPhoto: Bool
    
    var ableToEditPetProfile: Observable<Bool> = Observable(true)
    var textFieldState: Observable<BaseTextFieldState> = Observable(.isEmpty)
    var textFieldCharacterCount: Observable<Int> = Observable(0)
    
    init(
        id: Int,
        name: String,
        photo: UIImage?,
        hasPhoto: Bool) {
            self.id = id
            self.name = name
            self.photo = photo
            self.hasPhoto = hasPhoto
        }
    
    func nameTextFieldDidChangeEvent(_ text: String) {
        self.name = text
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...9:
            textFieldState = .isWritten
        case 10...:
            textFieldState = .isFull
            
        default:
            textFieldState = .isEmpty
        }
        
        // 상태 변경 후 옵저버 호출
        self.textFieldState.value = textFieldState
    }
    
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool {
        print(#function)
        let limit = type.limit
        print("🦖 \(limit)")
        return name.count >= limit
    }

    
    
    func editCompleteButtonDidTap() {
        if ableToEditPetProfile.value {
            let editProfileData = EditProfileRequest(
                hasPhoto: hasPhoto,
                nickName: name,
                profileImage: photo
            )
        }
    }
    
    func deleteButtonDidTap() {
        self.photo = nil
        self.hasPhoto = false
    }
    
    func editPetProfileImageEvent(_ image: UIImage) {
        self.photo = image
        self.hasPhoto = true
    }
}

