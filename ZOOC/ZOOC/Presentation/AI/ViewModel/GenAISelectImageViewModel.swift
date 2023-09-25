//
//  GenAISelectImageViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI
import MobileCoreServices

final class GenAISelectImageViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let genAISelectImageUseCase: GenAISelectImageUseCase
    
    init(genAISelectImageUseCase: GenAISelectImageUseCase) {
        self.genAISelectImageUseCase = genAISelectImageUseCase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var reloadData: Observable<Void>
        var generateAIModelButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var petImageDatasets = BehaviorRelay<[UIImage]>(value: [])
        var ableToShowImages = BehaviorRelay<Bool>(value: false)
        var uploadCompleted = BehaviorRelay<Bool?>(value: nil)
        var convertCompleted = BehaviorRelay<Bool?>(value: nil)
        var uploadRequestCompleted = BehaviorRelay<Bool?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(onNext: {
            self.genAISelectImageUseCase.loadImageEvent()
        }).disposed(by: disposeBag)
        
        input.reloadData.subscribe(onNext: {
            self.genAISelectImageUseCase.reloadEvent()
        }).disposed(by: disposeBag)
        
        input.generateAIModelButtonDidTapEvent.subscribe(onNext: {
            self.genAISelectImageUseCase.uploadGenAIDataset()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        genAISelectImageUseCase.petImageDatasets.subscribe(onNext: { petImageDatasets in
            output.petImageDatasets.accept(petImageDatasets)
        }).disposed(by: disposeBag)
        
        genAISelectImageUseCase.ableToShowImages.subscribe(onNext: { canShow in
            output.ableToShowImages.accept(canShow)
        }).disposed(by: disposeBag)
        
        genAISelectImageUseCase.convertCompleted.subscribe(onNext: { convertCompleted in
            output.convertCompleted.accept(convertCompleted)
        }).disposed(by: disposeBag)
        
        genAISelectImageUseCase.uploadRequestCompleted.subscribe(onNext: { uploadRequestCompleted in
            output.uploadRequestCompleted.accept(uploadRequestCompleted)
        }).disposed(by: disposeBag)
        
        genAISelectImageUseCase.uploadCompleted.subscribe(onNext: { uploadCompleted in
            output.uploadCompleted.accept(uploadCompleted)
        }).disposed(by: disposeBag)
    }
}

    
    
    
