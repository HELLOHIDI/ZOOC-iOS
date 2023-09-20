//
//  GenAIGuideUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/20.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

protocol GenAIGuideUseCase {
    var selectedImageDatasets: BehaviorRelay<[PHPickerResult]> { get }
    var ableToPhotoUpload: BehaviorRelay<Bool?> { get }
    func clearImageDatasets()
    func canUploadImageDatasets(_ result: [PHPickerResult])
}
