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
//
//protocol GenAIGuideViewModelInput {
//    func viewWillDisappearEvent()
//    func keepButtonTapEvent()
//    func didFinishChoosingPhotosEvent(results: [PHPickerResult])
//}
//
//protocol GenAIGuideViewModelOutput {
//    var selectedImageDatasets: ObservablePattern<[PHPickerResult]> { get }
//    var enablePhotoUpload: ObservablePattern<Bool?> { get }
//    var isPopped: ObservablePattern<Bool> { get }
//}
//
//typealias GenAIGuideViewModel = GenAIGuideViewModelInput & GenAIGuideViewModelOutput

final class GenAIGuideViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let genAIGuideUseCase: GenAIGuideUseCase
    
    init(genAIGuideUseCase: GenAIGuideUseCase) {
        self.genAIGuideUseCase = genAIGuideUseCase
    }
    
    struct Input {
        var viewWillDisappearEvent: Observable<Void>
        var didFinishPickingImageEvent: Observable<[PHPickerResult]>
    }
    
    struct Output {
        var selectedImageDatasets = BehaviorRelay<[PHPickerResult]>(value: [])
        var ableToPhotoUpload = BehaviorRelay<Bool?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillDisappearEvent.subscribe(onNext: {
            self.genAIGuideUseCase.clearImageDatasets()
        }).disposed(by: disposeBag)
        
        input.didFinishPickingImageEvent.subscribe(onNext: { result in
            self.genAIGuideUseCase.canUploadImageDatasets(result)
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
    }
    
    
    var isPopped: ObservablePattern<Bool> = ObservablePattern(false)
}

extension GenAIGuideViewModel {
    func getSelectedImageDatasets() -> [PHPickerResult] {
        return genAIGuideUseCase.selectedImageDatasets.value
    }
}
