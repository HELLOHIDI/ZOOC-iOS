//
//  DefaultRecordUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/01.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultRecordUseCase: RecordUseCase {

    private let disposeBag = DisposeBag()
    
    var image = BehaviorRelay<UIImage?>(value: nil)
    var content = BehaviorRelay<String?>(value: nil)
    var ableToRecord = BehaviorRelay<Bool?>(value: nil)
    
    func checkRecordingValidation() {
        let imageValidation = checkImageValidation()
        let contentValidation = checkContentValidation()
        
        ableToRecord.accept(imageValidation && contentValidation)
    }
    
    func selectRecordImage(_ image: UIImage) {
        self.image.accept(image)
    }
    
    func updateContent(_ text: String) {
        
        content.accept(text)
        switch text {
        case TextLiteral.recordPlaceHolderText:
            ableToRecord.accept(false)
            content.accept("")
        case "":
            ableToRecord.accept(false)
            content.accept(TextLiteral.recordPlaceHolderText)
        default:
            ableToRecord.accept(true)
        }
    }
}

extension DefaultRecordUseCase {
    func checkImageValidation() -> Bool {
        return image.value != nil
    }
    
    func checkContentValidation() -> Bool {
        guard let content = content.value else { return false }
        return !(content == TextLiteral.recordPlaceHolderText || content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
}
