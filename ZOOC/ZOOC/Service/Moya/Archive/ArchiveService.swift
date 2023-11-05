//
//  HomeService.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation

import Moya

enum ArchiveService {
    case getArchive(familyID: String, recordID: Int, petID: Int)
    case postComment(recordID: Int, comment: String)
    case postEmojiComment(recordID: Int, emojiID: Int)
    case deleteArchive(recordID: Int)
    case deleteComment(commentID: Int)
}

extension ArchiveService: BaseTargetType {
     
    var path: String {
        
        switch self {
        case .getArchive(familyID: let familyID,
                                  recordID: let recordID,
                                  petID: let petID):
            return URLs.detailPetRecord
                .replacingOccurrences(of: "{familyId}", with: familyID)
                .replacingOccurrences(of: "{petId}", with: String(petID))
                .replacingOccurrences(of: "{recordId}", with: String(recordID))
            
        case .postComment(recordID: let recordID, comment: _):
            return URLs.postComment
                .replacingOccurrences(of: "{recordId}", with: String(recordID))
            
        case .postEmojiComment(recordID: let recordID, emojiID: _):
            return URLs.postEmojiComment
                .replacingOccurrences(of: "{recordId}", with: String(recordID))
            
        case .deleteArchive(recordID: let recordID):
            return URLs.deleteRecord
                .replacingOccurrences(of: "{recordId}", with: String(recordID))
            
        case .deleteComment(commentID: let commentID):
            return URLs.deleteComment
                .replacingOccurrences(of: "{commentId}", with: String(commentID))
        }
    }
        
    var method: Moya.Method {
        switch self {
        case .postComment:
            return .post
            
        case .getArchive:
            return .get
            
        case .postEmojiComment:
            return .post
            
        case .deleteArchive:
            return .delete
            
        case .deleteComment:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getArchive:
            return .requestPlain
            
        case .postComment(recordID: _, comment: let comment):
            let body = ArchiveCommentReqeust(content: comment)
            return .requestJSONEncodable(body)
            
        case .postEmojiComment(recordID: _, emojiID: let emojiID):
            let body = ArchiveEmojiCommentReqeust(emoji: emojiID)
            return .requestJSONEncodable(body)
            
        case .deleteArchive:
            return .requestPlain
            
        case .deleteComment:
            return .requestPlain
            
        }
    }
}

