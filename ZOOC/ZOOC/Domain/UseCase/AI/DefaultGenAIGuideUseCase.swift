//
//  DefaultGenAIGuideUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/20.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

final class DefaultGenAIGuideUseCase: GenAIGuideUseCase {
    private let disposeBag = DisposeBag()
    
    var selectedImageDatasets = BehaviorRelay<[PHPickerResult]>(value: [])
    var ableToPhotoUpload = BehaviorRelay<Bool?>(value: nil)
    
    func clearImageDatasets() {
        selectedImageDatasets.accept([])
    }
    
    func canUploadImageDatasets(_ result: [PHPickerResult]) {
        if 8 <= result.count && result.count <= 15 {
            selectedImageDatasets.accept(result)
            ableToPhotoUpload.accept(true)
        } else {
            selectedImageDatasets.accept([])
            ableToPhotoUpload.accept(false)
        }
     }
}
