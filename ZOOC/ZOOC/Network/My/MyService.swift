//
//  MyService.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit

import Moya

enum MyService {
    case getMyPageData
    case patchUserProfile(isPhoto: Bool, nickName: String, photo: UIImage?)
    case deleteAccount
}

extension MyService: BaseTargetType {
    var path: String {
        switch self {
        case .getMyPageData:
            return "/family/mypage"
        case .patchUserProfile(isPhoto: let isPhoto, nickName: let nickName, photo: let photo):
            return "/user/profile"
        case .deleteAccount:
            return "/user"
        }
     
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageData:
            return .get
        case .patchUserProfile:
            return .patch
        case .deleteAccount:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyPageData:
            return .requestPlain
        case .patchUserProfile(isPhoto: let isPhoto, nickName: let nickName, photo: let photo):
            
            var multipartFormData: [MultipartFormData] = []
            
            let nickNameData = MultipartFormData(provider: .data(nickName.data(using: String.Encoding.utf8)!),
                                                           name: "nickName",
                                                           mimeType: "application/json")
            if let photo = photo{
                print("포토있음")
                let photo = photo.jpegData(compressionQuality: 1.0) ?? Data()
                let imageData = MultipartFormData(provider: .data(photo),
                                                              name: "file",
                                                              fileName: "image.jpeg",
                                                              mimeType: "image/jpeg")
                multipartFormData.append(imageData)
            }
          
            
            multipartFormData.append(nickNameData)
            return .uploadCompositeMultipart(multipartFormData, urlParameters: ["photo": isPhoto ? "true" : "false"])


        case .deleteAccount:
            return .requestPlain
        }
    }
    
    var headers: [String : String]?{
        return APIConstants.hasTokenHeader
    }
}

