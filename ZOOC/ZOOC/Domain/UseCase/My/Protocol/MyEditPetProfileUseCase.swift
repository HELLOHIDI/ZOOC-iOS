//
//  MyEditPetProfileUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol MyEditPetProfileUseCase {
    var id: BehaviorRelay<Int?> { get }
    var petProfileData:BehaviorRelay<EditPetProfileRequest?> { get }
    var textFieldState: BehaviorRelay<BaseTextFieldState> { get }
    var ableToEditProfile: BehaviorRelay<Bool> { get }
    var isTextCountExceeded: BehaviorRelay<Bool> { get }
    var isEdited: PublishRelay<Bool> { get set}
    
    func editProfile()
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType)
    func nameTextFieldDidChangeEvent(_ text: String?)
    func deleteProfileImage()
    func selectProfileImage(_ image: UIImage)
}

