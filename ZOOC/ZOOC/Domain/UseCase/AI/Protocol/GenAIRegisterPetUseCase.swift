//
//  GenAIRegisterPetUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/11.
//

import UIKit

import RxSwift
import RxCocoa

protocol GenAIRegisterPetUseCase {
    var petId: BehaviorRelay<Int?> { get set }
    var textFieldState: BehaviorRelay<BaseTextFieldState> { get }
    var canRegisterPet: BehaviorRelay<Bool> { get set }
    var isRegistedPet: BehaviorRelay<Bool> { get set }
    var isTextCountExceeded: BehaviorRelay<Bool> {get set}
    var name: BehaviorRelay<String> { get set}
    var photo: BehaviorRelay<UIImage?> { get set}
    
    func registerProfileImage(_ image: UIImage)
    func registerPet()
    func isTextCountExceeded(for type: ZoocEditTextField.TextFieldType)
    func nameTextFieldDidChangeEvent(_ text: String?)
}

