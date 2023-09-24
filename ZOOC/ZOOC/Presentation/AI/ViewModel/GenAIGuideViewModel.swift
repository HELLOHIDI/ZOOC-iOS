//
//  GenAIGuideViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

final class GenAIGuideViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let genAIGuideUseCase: GenAIGuideUseCase
    
    init(genAIGuideUseCase: GenAIGuideUseCase) {
        self.genAIGuideUseCase = genAIGuideUseCase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var viewWillDisappearEvent: Observable<Void>
        var didFinishPickingImageEvent: Observable<[PHPickerResult]>
        var pushToGenAISelectImageVCEvent: Observable<Void>
    }
    
    struct Output {
        var selectedImageDatasets = BehaviorRelay<[PHPickerResult]>(value: [])
        var ableToPhotoUpload = BehaviorRelay<Bool?>(value: nil)
        var isPushed = BehaviorRelay<Bool?>(value: nil)
        var isPopped = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(onNext: {
            self.genAIGuideUseCase.checkPresentPHPPickerVC()
        }).disposed(by: disposeBag)
        
        input.viewWillDisappearEvent.subscribe(onNext: {
            self.genAIGuideUseCase.clearImageDatasets()
        }).disposed(by: disposeBag)
        
        input.didFinishPickingImageEvent.subscribe(onNext: { result in
            self.genAIGuideUseCase.canUploadImageDatasets(result)
        }).disposed(by: disposeBag)
        
        input.pushToGenAISelectImageVCEvent.subscribe(onNext: {
            self.genAIGuideUseCase.pushToSelectImageVCEvent()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        genAIGuideUseCase.selectedImageDatasets.subscribe(onNext: { imageDatasets in
            output.selectedImageDatasets.accept(imageDatasets)
        }).disposed(by: disposeBag)
        
        genAIGuideUseCase.ableToPhotoUpload.subscribe(onNext: { canUpload in
            output.ableToPhotoUpload.accept(canUpload)
        }).disposed(by: disposeBag)
        
        genAIGuideUseCase.isPushed.subscribe(onNext: { isPushed in
            output.isPushed.accept(isPushed)
        }).disposed(by: disposeBag)
        
        genAIGuideUseCase.isPopped.subscribe(onNext: { isPopped in
            output.isPopped.accept(isPopped)
        }).disposed(by: disposeBag)
    }
}

extension GenAIGuideViewModel {
    func getSelectedImageDatasets() -> [PHPickerResult] {
        return genAIGuideUseCase.selectedImageDatasets.value
    }
    
    func getPetId() -> Int? {
        guard let petId = genAIGuideUseCase.petId.value else { return nil}
        return petId
    }
}
