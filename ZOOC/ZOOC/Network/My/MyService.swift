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
    case patchUserProfile(_ request: EditProfileRequest)
    case patchPetProfile(_ request: EditPetProfileRequest, _ id: Int)
    case deleteAccount
    case postRegisterPets(_ request: MyRegisterPetsRequest)
    case postRegisterPet(_ request: MyRegisterPetRequest)
    case logout
}

extension MyService: BaseTargetType {
    var path: String {
        switch self {
        case .getMyPageData:
            return URLs.myPage.replacingOccurrences(of: "{familyId}", with: UserDefaultsManager.familyID)
        case .patchUserProfile:
            return URLs.editProfile
        case .deleteAccount:
            return URLs.deleteUser
        case .postRegisterPets(param: _):
            return URLs.registerPets.replacingOccurrences(of: "{familyId}", with: UserDefaultsManager.familyID)
        case .postRegisterPet(param: _):
            return URLs.registerPet.replacingOccurrences(of: "{familyId}", with: UserDefaultsManager.familyID)
        case .logout:
            return URLs.logout
        case .patchPetProfile(_, let id):
            return URLs.patchPet.replacingOccurrences(of: "{petId}", with: "\(id)")
            
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
        case .postRegisterPets(param: _):
            return .post
        case .postRegisterPet(param: _):
            return .post
        case .logout:
            return .delete
        case .patchPetProfile:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyPageData:
            return .requestPlain
            
        case .patchUserProfile(let request):
            
            var multipartFormData: [MultipartFormData] = []
            
            let nickNameData = MultipartFormData(provider: .data(request.nickName.data(using: String.Encoding.utf8)!),
                                                 name: "name",
                                                 mimeType: "application/json")
            if let photo = request.profileImage{
                let photo = photo.jpegData(compressionQuality: 1.0) ?? Data()
                let imageData = MultipartFormData(provider: .data(photo),
                                                  name: "photo",
                                                  fileName: "image.jpeg",
                                                  mimeType: "image/jpeg")
                multipartFormData.append(imageData)
            }
            
            
            multipartFormData.append(nickNameData)
            return .uploadCompositeMultipart(multipartFormData, urlParameters: ["photo": request.hasPhoto ? "true" : "false" ])
            
            
        case .deleteAccount:
            return .requestPlain
            
        case .postRegisterPets(param: let param):
            var multipartFormDatas: [MultipartFormData] = []
            
            for name in param.petNames {
                multipartFormDatas.append(MultipartFormData(
                    provider: .data("\(name)".data(using: .utf8)!),
                    name: "petNames[]"))
            }
            
            //photo! 나중에 바꿔주기
            for photo in param.files {
                multipartFormDatas.append(MultipartFormData(
                    provider: .data(photo!),
                    name: "files",
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg"))
            }
            
            for isPhoto in param.isPetPhotos {
                multipartFormDatas.append(MultipartFormData(
                    provider: .data("\(isPhoto)".data(using: .utf8)!),
                    name: "isPetPhotos[]"))
            }
            
            return .uploadMultipart(multipartFormDatas)
            
        case .postRegisterPet(param: let param):
            var multipartFormData: [MultipartFormData] = []
            
            let nameData = MultipartFormData(provider: .data(param.name.data(using: String.Encoding.utf8)!),
                                                 name: "name",
                                                 mimeType: "application/json")
            multipartFormData.append(nameData)
            
            if let photo = param.photo{
                print("포토있음")
                let photo = photo.jpegData(compressionQuality: 1.0) ?? Data()
                let imageData = MultipartFormData(provider: .data(photo),
                                                  name: "photo",
                                                  fileName: "image.jpeg",
                                                  mimeType: "image/jpeg")
                multipartFormData.append(imageData)
            }
            
            return .uploadMultipart(multipartFormData)
            
        case .logout:
            return .requestParameters(parameters: ["fcmToken": UserDefaultsManager.fcmToken],
                                      encoding: JSONEncoding.default)
        case .patchPetProfile(let request, _):
            var multipartFormDates: [MultipartFormData] = []
            multipartFormDates.append(
                MultipartFormData(
                    provider: .data(request.nickName.data(using: .utf8)!),
                    name: "nickName"
                )
            )
            if let photo = request.file {
                print("포토있음")
                let photo = photo.jpegData(compressionQuality: 1.0) ?? Data()
                multipartFormDates.append(
                    MultipartFormData(
                        provider: .data(photo),
                        name: "file",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg"
                    )
                )
            }
            return .uploadCompositeMultipart(multipartFormDates, urlParameters: ["photo" : request.photo ? "true" : "false"] )
        }
    }
    var headers: [String : String]? {
        switch self {
        case .getMyPageData:
            return APIConstants.hasTokenHeader
        case .patchUserProfile:
            return APIConstants.hasTokenHeader
        case .deleteAccount:
            return APIConstants.hasTokenHeader
        case .postRegisterPets(param: _):
            return APIConstants.multipartHeader
        case .postRegisterPet(param: _):
            return APIConstants.multipartHeader
        case .logout:
            return APIConstants.hasTokenHeader
        case .patchPetProfile:
            return APIConstants.multipartHeader
        }
    }
}
