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
}

extension DefaultRecordUseCase {
    func checkImageValidation() -> Bool {
        return image.value != nil
    }
    
    func checkContentValidation() -> Bool {
        let placeHoldText: String = """
                                    ex) 2023년 2월 30일
                                    가족에게 어떤 순간이었는지 남겨주세요
                                    """
        guard let content = content.value else { return false }
        return !(content == placeHoldText || content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
}
