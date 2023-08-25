//
//  GenAIGuideViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

import UIKit

import PhotosUI

protocol GenAIGuideViewModelInput {
    func viewWillDisappearEvent()
    func keepButtonTapEvent()
    func didFinishChoosingPhotosEvent(results: [PHPickerResult])
}

protocol GenAIGuideViewModelOutput {
    var selectedImageDatasets: Observable<[PHPickerResult]> { get }
    var enablePhotoUpload: Observable<Bool?> { get }
    var isPopped: Observable<Bool> { get }
}

typealias GenAIGuideViewModel = GenAIGuideViewModelInput & GenAIGuideViewModelOutput

final class DefaultGenAIGuideViewModel: GenAIGuideViewModel {
    
    var selectedImageDatasets: Observable<[PHPickerResult]> = Observable([])
    var enablePhotoUpload: Observable<Bool?> = Observable(nil)
    var isPopped: Observable<Bool> = Observable(false)
    
    func viewWillDisappearEvent() {
        selectedImageDatasets.value = []
    }
    
    func keepButtonTapEvent() {
        selectedImageDatasets.value = []
    }
    
    func didFinishChoosingPhotosEvent(results: [PHPickerResult]) {
        for result in results {
            selectedImageDatasets.value.append(result)
        }
        
        if 8 <= selectedImageDatasets.value.count && selectedImageDatasets.value.count <= 15 {
            enablePhotoUpload.value = true
        } else {
            enablePhotoUpload.value = false
        }
    }
}

