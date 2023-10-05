//
//  PetAiResult.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/06.
//

import Foundation

enum PetAiState {
    case notStarted
    case inProgress
    case done
}

struct PetAiResult {
    let id: Int
    let name: String
    let photo: String?
    let state: PetAiState
}
