//
//  GenAIService.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

import UIKit

import Moya

enum GenAIService {
    case postDataset(petId: Int)
    case getPetDataset(petId: String)
    case patchDatasetImage(datasetId: String, file: UIImage)
    case patchDatasetImages(datasetId: String, files: [UIImage])
}

extension GenAIService: BaseTargetType {
    var path: String {
        switch self {
        case .postDataset:
            return URLs.postDataset
        case .getPetDataset(let petId):
            return URLs.getPetDataset.replacingOccurrences(of: "{petId}", with: petId)
        case .patchDatasetImage(let datasetId, file: _):
            return URLs.patchDatasetImage.replacingOccurrences(of: "{datasetId}", with: datasetId)
        case .patchDatasetImages(let datasetId, files: _):
            return URLs.patchDatasetImage.replacingOccurrences(of: "{datasetId}", with: datasetId)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postDataset:
            return .post
        case .getPetDataset:
            return .get
        case .patchDatasetImage:
            return .patch
        case .patchDatasetImages:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postDataset(let petId):
            return .requestJSONEncodable(["petId": petId])
        case .getPetDataset:
            return .requestPlain
        case .patchDatasetImage(datasetId: _, let file):
            var multipartFormData: [MultipartFormData] = []
            
            let file = file.jpegData(compressionQuality: 1.0) ?? Data()
            let imageData = MultipartFormData(provider: .data(file),
                                              name: "file",
                                              fileName: "image.jpeg",
                                              mimeType: "image/jpeg")
            multipartFormData.append(imageData)
            
            
            
            return .uploadMultipart(multipartFormData)
            
        case .patchDatasetImages(datasetId: _, let files):
            var multipartFormDatas: [MultipartFormData] = []
            
            for file in files {
                let photo = file.jpegData(compressionQuality: 1.0) ?? Data()
                multipartFormDatas.append(MultipartFormData(
                    provider: .data(photo),
                    name: "files",
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(multipartFormDatas)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postDataset:
            return APIConstants.hasTokenHeader
        case .getPetDataset:
            return APIConstants.hasTokenHeader
        case .patchDatasetImage:
            return APIConstants.multipartHeader
        case .patchDatasetImages:
            return APIConstants.multipartHeader
        }
    }
}


