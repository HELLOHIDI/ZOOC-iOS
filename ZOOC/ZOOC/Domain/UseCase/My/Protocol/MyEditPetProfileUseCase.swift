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
    var name: BehaviorRelay<String?> { get }
    var petProfileData:BehaviorRelay<EditPetProfileRequest?> { get }
    var textFieldState: BehaviorRelay<BaseTextFieldState> { get }
    var ableToEditProfile: BehaviorRelay<Bool> { get }
    var isTextCountExceeded: BehaviorRelay<Bool> { get }
    var isEdited: BehaviorRelay<Bool?> { get set}
    
    func editProfile(_ image: UIImage?)
    func isTextCountExceeded(for type: MyEditTextField.TextFieldType)
    func nameTextFieldDidChangeEvent(_ text: String?)
}

