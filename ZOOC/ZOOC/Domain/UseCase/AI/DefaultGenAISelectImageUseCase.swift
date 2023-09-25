//
//  DefaultGenAISelectImageUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/21.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

final class DefaultGenAISelectImageUseCase: GenAISelectImageUseCase {
    private let repository: GenAIModelRepository
    private let disposeBag = DisposeBag()
    
    init(
        petId: Int?,
        selectedImageDatesets: [PHPickerResult],
        repository: GenAIModelRepository
    ) {
        self.petId.accept(petId)
        self.selectedImageDatasets.accept(selectedImageDatesets)
        self.repository = repository
    }
    
    var petId = BehaviorRelay<Int?>(value: nil)
    var selectedImageDatasets = BehaviorRelay<[PHPickerResult]>(value: [])
    var petImageDatasets = BehaviorRelay<[UIImage]>(value: [])
    var ableToShowImages = BehaviorRelay<Bool>(value: false)
    var uploadCompleted = BehaviorRelay<Bool?>(value: nil)
    var convertCompleted = BehaviorRelay<Bool?>(value: nil)
    var uploadRequestCompleted = BehaviorRelay<Bool?>(value: nil)
    
    func loadImageEvent() {
        let dispatchGroup = DispatchGroup()
        var updatePetImageDatasets: [UIImage] = []
        
        for index in 0..<selectedImageDatasets.value.count {
            let itemProvider = selectedImageDatasets.value[index].itemProvider
            
            dispatchGroup.enter()
            itemProvider.loadImage { image, error in
                if let image = image {
                    DispatchQueue.main.async {
                        updatePetImageDatasets.append(image)
                        dispatchGroup.leave()
                    }
                }
                if let error = error {
                    print("Image Loading Error: \(error)")
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.petImageDatasets.accept(updatePetImageDatasets)
            self.convertCompleted.accept(true)
        }
    }
    
    func reloadEvent() {
        if petImageDatasets.value.count > 0 && selectedImageDatasets.value.count == petImageDatasets.value.count {
            ableToShowImages.accept(true)
        } else {
            ableToShowImages.accept(false)
        }
    }
    
    func uploadGenAIDataset() {
        guard let petId = petId.value else { return }
        repository.postMakeDataset(petId: petId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.uploadRequestCompleted.accept(true)
                guard let result = data as? GenAIDatasetResult else { return }
                self.patchDatasetsImages(
                    datasetId: result.datasetId,
                    files: self.petImageDatasets.value)
                
                self.postRecordDatasetImages(
                    familyId: UserDefaultsManager.familyID,
                    content: nil,
                    files: self.petImageDatasets.value,
                    pet: petId)
            default:
                self.uploadRequestCompleted.accept(false)
            }
            
        }
    }
    
    func patchDatasetsImages(datasetId: String, files: [UIImage]) {
        repository.patchDatasetImages(datasetId: datasetId, files: files) { [weak self] result in
            switch result {
            case .success(_):
                self?.uploadCompleted.accept(true)
            default:
                self?.uploadCompleted.accept(false)
            }
        }
    }
    
    func postRecordDatasetImages(familyId: String, content: String?, files: [UIImage], pet: Int) {
        repository.postRecordDatasetImages(familyId: familyId, content: content, files: files, pet: pet) {  result in
            switch result {
            case .success(_):
                print("🆗 AI 모델 생성을 위한 데이터셋 이미지가 잘 기록되었습니다")
            default:
                print("❌ AI 모델 생성을 위한 데이터셋 이미지가 기록되지 않았습니다")
            }
        }
    }
}
