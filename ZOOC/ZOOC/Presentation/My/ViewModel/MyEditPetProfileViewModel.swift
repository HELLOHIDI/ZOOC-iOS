//
//  MyEditPetProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

//protocol MyEditPetProfileModelInput {
//    func nameTextFieldDidChangeEvent(_ text: String)
//    func editCompleteButtonDidTap()
//    func deleteButtonDidTap()
//    func editPetProfileImageEvent(_ image: UIImage)
//    func isTextCountExceeded(for type: MyEditTextField.TextFieldType) -> Bool
//}
//
//protocol MyEditPetProfileModelOutput {
//    var ableToEditPetProfile: ObservablePattern<Bool> { get }
//    var textFieldState: ObservablePattern<BaseTextFieldState> { get }
//    var editCompletedOutput: ObservablePattern<Bool?> { get }
//    var editPetProfileDataOutput: ObservablePattern<EditPetProfileRequest> { get }
//
//}


final class MyEditPetProfileViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let myEditProfileUseCase: MyEditProfileUseCase
    
    init(myEditProfileUseCase: MyEditProfileUseCase) {
        self.myEditProfileUseCase = myEditProfileUseCase
    }
    
    struct Input {
        var nameTextFieldDidChangeEvent: Observable<String?>
        var registerPetButtonTapEvent: Observable<UIImage>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
       
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        
    }
}
