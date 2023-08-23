//
//  GenAISelectImageViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit
import PhotosUI

protocol GenAISelectImageViewModelInput {
    func viewWillAppearEvent()
}

protocol GenAISelectImageViewModelOutput {
    var selectedImageDatasets : Observable<[PHPickerResult]> { get }
    var petImageDatasets : Observable<[UIImage]> { get }
}

typealias GenAISelectImageViewModel = GenAISelectImageViewModelInput & GenAISelectImageViewModelOutput

final class DefaultGenAISelectImageViewModel: GenAISelectImageViewModel {
    
    var selectedImageDatasets: Observable<[PHPickerResult]> = Observable([])
    var petImageDatasets: Observable<[UIImage]> = Observable([])
    
    init(selectedImageDatasets: [PHPickerResult]) {
        self.selectedImageDatasets.value = selectedImageDatasets
    }
    
    func viewWillAppearEvent() {
        selectedImageDatasets.value.forEach { result in
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        self.petImageDatasets.value.append(image)
                        // 이미지 처리는 여기서...
                        /*
                         만약 이 부분에서 UI 변경 관련 코드를 작성할 때는
                         DispatchQueue를 사용해 main에서 실행해줘야한다
                         */
                    }
                    if let error = error {
                        print("삐용삐용 \(error)")
                    }
                }
            }
        }
    }
}

