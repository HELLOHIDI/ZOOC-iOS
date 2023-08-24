//
//  GenAISelectImageViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import PhotosUI
import MobileCoreServices

protocol GenAISelectImageViewModelInput {
    func viewWillAppearEvent()
    func reloadDataEvent()
}

protocol GenAISelectImageViewModelOutput {
    var selectedImageDatasets : Observable<[PHPickerResult]> { get }
    var petImageDatasets : Observable<[UIImage]> { get }
    var showEnabled: Observable<Bool> { get }
}

typealias GenAISelectImageViewModel = GenAISelectImageViewModelInput & GenAISelectImageViewModelOutput

final class DefaultGenAISelectImageViewModel: GenAISelectImageViewModel {
    
    
    
    var selectedImageDatasets: Observable<[PHPickerResult]> = Observable([])
    var petImageDatasets: Observable<[UIImage]> = Observable([])
    var showEnabled: Observable<Bool> = Observable(false)
    
    init(selectedImageDatasets: [PHPickerResult]) {
        self.selectedImageDatasets.value = selectedImageDatasets
    }
    
    func viewWillAppearEvent() {
        let dispatchGroup = DispatchGroup()
        
        for index in 0..<selectedImageDatasets.value.count {
            let itemProvider = selectedImageDatasets.value[index].itemProvider
            
            dispatchGroup.enter()
            itemProvider.loadImage { image, error in
                if let image = image {
                    DispatchQueue.main.async {
                        self.petImageDatasets.value.append(image)
                        dispatchGroup.leave()
                    }
                }
                if let error = error {
                    print("Image Loading Error: \(error)")
                    dispatchGroup.leave()
                }
            }
        }
        
        // 모든 이미지 변환이 완료될 때까지 대기
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.reloadDataEvent() // 모든 변환이 끝나면 reloadDataEvent 호출
        }
    }
    
    func reloadDataEvent() {
        if petImageDatasets.value.count > 0 && selectedImageDatasets.value.count == petImageDatasets.value.count {
            showEnabled.value = true
        } else {
            showEnabled.value = false
        }
    }
}
