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

    init(id: Int = Int(),
         name: String = String(),
         photo: String? = nil,
         state: PetAiState = .notStarted) {
        self.id = id
        self.name = name
        self.photo = photo
        self.state = state
    }
}
