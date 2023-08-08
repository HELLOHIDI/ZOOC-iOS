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
}

final class MyEditPetProfileViewModel: MyEditPetProfileModelInput, MyEditPetProfileModelOutput {
    var id: Int
    var name: String
    var photo: UIImage?
    var hasPhoto: Bool
    var ableToEditPetProfile: Observable<Bool> = Observable(true)
    
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

