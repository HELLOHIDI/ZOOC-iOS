//
//  GenAIPetDatasetsResult.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

struct GenAIPetDatasetsResult: Codable {
    let datasetID, datasetName, createdAt: String
    let description: String? =  nil
    let updatedAt: String
    let datasetImages: [DatasetImage]

    enum CodingKeys: String, CodingKey {
        case datasetID = "datasetId"
        case datasetName, createdAt, description, updatedAt
        case datasetImages = "dataset_images"
    }
}

// MARK: - DatasetImage
struct DatasetImage: Codable {
    let url: String
    let id, createdAt: String
}
