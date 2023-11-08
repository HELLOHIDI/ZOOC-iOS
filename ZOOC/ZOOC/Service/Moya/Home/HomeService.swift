//
//  HomeService.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation

import Moya

enum HomeService {
    case getTotalPet(familyID: String)
    case getTotalArchive(familyID: String, petID: String, limit: String, after: Int?)
    case getDetailPetArchive(familyID: String, recordID: Int, petID: Int)
    case getNotice(familyID: String)
    case postComment(recordID: Int, comment: String)
    case postEmojiComment(recordID: Int, emojiID: Int)
}

extension HomeService: BaseTargetType {
    
    var path: String {
        switch self {
        case .getTotalPet(let familyID):
            return URLs.totalPet
                .replacingOccurrences(of: "{familyId}", with: familyID)
            
        case .getTotalArchive(familyID: let familyID, petID: let petID, limit: _, after: _):
            return URLs.totalRecord
                .replacingOccurrences(of: "{familyId}", with: familyID)
                .replacingOccurrences(of: "{petId}", with: petID)
            
        case .getDetailPetArchive(familyID: let familyID,
                                  recordID: let recordID,
                                  petID: let petID):
            return URLs.detailPetRecord
                .replacingOccurrences(of: "{familyId}", with: familyID)
                .replacingOccurrences(of: "{petId}", with: String(petID))
                .replacingOccurrences(of: "{recordId}", with: String(recordID))
            
        case .getNotice(let familyID):
            return URLs.getNotice
                .replacingOccurrences(of: "{familyId}", with: familyID)
            
        case .postComment(recordID: let recordID, comment: _):
            return URLs.postComment
                .replacingOccurrences(of: "{recordId}", with: String(recordID))
            
        case .postEmojiComment(recordID: let recordID, emojiID: _):
            return URLs.postEmojiComment
                .replacingOccurrences(of: "{recordId}", with: String(recordID))
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTotalPet:
            return .get
            
        case .getTotalArchive:
            return .get

        case .getNotice:
            return .get
            
        case .postComment:
            return .post
            
        case .getDetailPetArchive:
            return .get
            
        case .postEmojiComment:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getTotalPet:
            return .requestPlain
            
        case .getTotalArchive(familyID: _, petID: _, limit: let limit, after: let after):
            var parameters: [String: Any]
            if let after = after {
                parameters = ["limit" : limit, "after" : after]
            } else {
                parameters = ["limit" : limit]
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .getDetailPetArchive:
            return .requestPlain
            
        case .getNotice:
            return .requestPlain
            
        case .postComment(recordID: _, comment: let comment):
            let body = ArchiveCommentReqeust(content: comment)
            return .requestJSONEncodable(body)
            
        case .postEmojiComment(recordID: _, emojiID: let emojiID):
            let body = ArchiveEmojiCommentReqeust(emoji: emojiID)
            return .requestJSONEncodable(body)
        }
    }
}
