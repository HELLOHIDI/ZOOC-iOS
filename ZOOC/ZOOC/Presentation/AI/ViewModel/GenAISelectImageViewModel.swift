//
//  GenAISelectImageViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

protocol GenAISelectImageViewModelInput {
    
}

protocol GenAISelectImageViewModelOutput {
    var petImageDatasets : Observable<[UIImage]> { get }
}

typealias GenAISelectImageViewModel = GenAISelectImageViewModelInput & GenAISelectImageViewModelOutput

final class DefaultGenAISelectImageViewModel: GenAISelectImageViewModel {
    
    var petImageDatasets: Observable<[UIImage]> = Observable([])
    
    init(petImageDatasets: [UIImage]) {
        self.petImageDatasets.value = petImageDatasets
    }
}

