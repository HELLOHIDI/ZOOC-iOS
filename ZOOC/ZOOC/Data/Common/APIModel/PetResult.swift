//
//  PetResult.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/12.
//

import Foundation

struct PetResult: Codable {
    let id: Int
    let name: String
    let photo: String?
    let datasetID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, photo
        case datasetID = "dataset_id"
    }
}

extension PetResult {
    func transform()-> RecordRegisterModel{
        RecordRegisterModel(petID: self.id,
                            petImageURL: self.photo,
                            petName: self.name,
                            isSelected: false)
    }
    
    func toPetAiModel() -> PetAiModel {
        PetAiModel(id: id,
                    name: name,
                    photo: photo,
                    state: (datasetID == nil) ? .notStarted : .done)
    }
}
