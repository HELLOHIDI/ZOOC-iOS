//
//  ArchiveAPI.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/21.
//

import UIKit

import Moya

class ArchiveAPI: BaseAPI {
    static let shared = ArchiveAPI()
    var archiveProvider = MoyaProvider<ArchiveService>(session: Session(interceptor:
                                                                        ZoocInterceptor()),
                                                    plugins: [MoyaLoggingPlugin()])
    private override init() {}
}

extension ArchiveAPI{
    
    func getArchive(recordID: Int,
                    petID: Int,
                    completion: @escaping (NetworkResult<Any>) -> Void) {
        archiveProvider.request(.getArchive(familyID: UserDefaultsManager.familyID, recordID: recordID, petID: petID)) { (result) in
            self.disposeNetwork(result,
                                dataModel: ArchiveResult.self,
                                completion: completion)
        }
    }
    
    func postComment(recordID: String,
                     comment: String,
                     completion: @escaping (NetworkResult<Any>) -> Void) {
        archiveProvider.request(.postComment(recordID: recordID, comment: comment)) { (result) in
            self.disposeNetwork(result, dataModel: [CommentResult].self, completion: completion)
        }
    }
    
    func postEmojiComment(recordID: String,
                          emojiID: Int,
                          completion: @escaping (NetworkResult<Any>) -> Void) {
        archiveProvider.request(.postEmojiComment(recordID: recordID, emojiID: emojiID)) { (result) in
            self.disposeNetwork(result, dataModel: [CommentResult].self, completion: completion)
        }
    }
    
    func deleteArchive(recordID: String,
                       completion: @escaping (NetworkResult<Any>) -> Void) {
        archiveProvider.request(.deleteArchive(recordID: recordID)) { (result) in
            self.disposeNetwork(result,
                                dataModel: VoidResult.self,
                                completion: completion)
        }
    }
    
    func deleteComment(commentID: String,
                       completion: @escaping (NetworkResult<Any>) -> Void) {
        archiveProvider.request(.deleteComment(commentID: commentID)) { (result) in
            self.disposeNetwork(result,
                                dataModel: VoidResult.self,
                                completion: completion)
        }
    }

    
    
}


