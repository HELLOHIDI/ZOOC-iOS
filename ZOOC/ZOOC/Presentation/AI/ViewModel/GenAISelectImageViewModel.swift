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
    func generateAIModelButtonDidTapEvent()
    func observePetIdEvent(notification: Notification)
}

protocol GenAISelectImageViewModelOutput {
    var selectedImageDatasets : ObservablePattern<[PHPickerResult]> { get }
    var petImageDatasets : ObservablePattern<[UIImage]> { get }
    var showEnabled: ObservablePattern<Bool> { get }
    var isCompleted: ObservablePattern<Bool?> { get }
    var uploadRequestCompleted: ObservablePattern<Bool?> { get }
}

typealias GenAISelectImageViewModel = GenAISelectImageViewModelInput & GenAISelectImageViewModelOutput

final class DefaultGenAISelectImageViewModel: GenAISelectImageViewModel {
    
    private var petId: Int
    let repository: GenAIModelRepository
    
    var selectedImageDatasets: ObservablePattern<[PHPickerResult]> = ObservablePattern([])
    var petImageDatasets: ObservablePattern<[UIImage]> = ObservablePattern([])
    var showEnabled: ObservablePattern<Bool> = ObservablePattern(false)
    var isCompleted: ObservablePattern<Bool?> = ObservablePattern(nil)
    var uploadRequestCompleted: ObservablePattern<Bool?> = ObservablePattern(nil)
    
    
    init(petId: Int, selectedImageDatasets: [PHPickerResult], repository: GenAIModelRepository) {
        self.petId = petId
        self.selectedImageDatasets.value = selectedImageDatasets
        self.repository = repository
        
        print("selectedImageDatasets.value.isEmpty \(selectedImageDatasets.isEmpty)")
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
    
    func observePetIdEvent(notification: Notification) {
        guard let petId = notification.object as? Int else { return }
        self.petId = petId
    }
    
    func reloadDataEvent() {
        if petImageDatasets.value.count > 0 && selectedImageDatasets.value.count == petImageDatasets.value.count {
            showEnabled.value = true
        } else {
            showEnabled.value = false
        }
    }
    
    func generateAIModelButtonDidTapEvent() {
        repository.postMakeDataset(petId: petId) { [weak self] result in
            switch result {
            case .success(let data):
                self?.uploadRequestCompleted.value = true
                guard let result = data as? GenAIDatasetResult else { return }
                guard let files = self?.petImageDatasets.value else { return }
                guard let pet = self?.petId else { return }
                self?.patchDatasetsImages(datasetId: result.datasetId, files: files)
                self?.postRecordDatasetImages(familyId: UserDefaultsManager.familyID, content: nil, files: files, pet: pet)
            default:
                self?.uploadRequestCompleted.value = false
            }
            
        }
    }
    
    func patchDatasetsImages(datasetId: String, files: [UIImage]) {
        repository.patchDatasetImages(datasetId: datasetId, files: files) { [weak self] result in
            switch result {
            case .success(_):
                self?.isCompleted.value = true
            default:
                self?.isCompleted.value = false
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
