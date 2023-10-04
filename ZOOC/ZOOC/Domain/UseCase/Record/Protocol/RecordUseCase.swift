//
//  RecordViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/01.
//

import UIKit

import RxSwift
import RxCocoa

protocol RecordUseCase {
    var image: BehaviorRelay<UIImage?> { get }
    var content: BehaviorRelay<String?> { get }
    var ableToRecord: BehaviorRelay<Bool> { get }
    
    func checkRecordingValidation()
    func selectRecordImage(_ image: UIImage)
    func updateContent(_ text: String)
}

