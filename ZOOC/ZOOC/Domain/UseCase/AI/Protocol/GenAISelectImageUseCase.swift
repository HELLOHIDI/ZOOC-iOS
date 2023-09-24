//
//  GenAISelectImageUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/21.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

protocol GenAISelectImageUseCase {
    var petId: BehaviorRelay<Int?> { get set }
    var selectedImageDatasets: BehaviorRelay<[PHPickerResult]> { get set }
    var petImageDatasets: BehaviorRelay<[UIImage]> { get set }
    var ableToShowImages: BehaviorRelay<Bool> { get set }
    var convertCompleted: BehaviorRelay<Bool?> { get set }
    var uploadCompleted: BehaviorRelay<Bool?> { get set }
    var uploadRequestCompleted: BehaviorRelay<Bool?> { get set }
    
    func loadImageEvent()
    func reloadEvent()
    func uploadGenAIDataset()
}

