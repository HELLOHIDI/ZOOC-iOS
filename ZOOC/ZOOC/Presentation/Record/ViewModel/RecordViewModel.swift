//
//  RecordViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/01.
//

import UIKit

import RxSwift
import RxCocoa

final class RecordViewModel: ViewModelType {
    private let recordUseCase: RecordUseCase
    
    init(recordUseCase: RecordUseCase) {
        self.recordUseCase = recordUseCase
    }
    
    struct Input {
        let selectRecordImageEvent: Observable<UIImage>
        let textViewDidTapEvent: Observable<String>
    }
    
    struct Output {
        var image = BehaviorRelay<UIImage?>(value: nil)
        var content = BehaviorRelay<String?>(value: nil)
        var ableToRecord = BehaviorRelay<Bool?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.selectRecordImageEvent.subscribe(with: self, onNext: { owner, image in
            owner.recordUseCase.selectRecordImage(image)
        }).disposed(by: disposeBag)
        
        input.textViewDidTapEvent.subscribe(with: self, onNext: { owner, content in
            owner.recordUseCase.updateContent(content)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        recordUseCase.image.subscribe(onNext: { image in
            output.image.accept(image)
        }).disposed(by: disposeBag)
        
        recordUseCase.content.subscribe(onNext: { content in
            output.content.accept(content)
        }).disposed(by: disposeBag)
        
        recordUseCase.ableToRecord.subscribe(onNext: { canRecord in
            output.ableToRecord.accept(canRecord)
        }).disposed(by: disposeBag)
    }
}
