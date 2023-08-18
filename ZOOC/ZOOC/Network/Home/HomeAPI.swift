//
//  HomeAPI.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit
import Moya

class HomeAPI: BaseAPI {
    static let shared = HomeAPI()
    var homeProvider = MoyaProvider<HomeService>(session: Session(interceptor: ZoocInterceptor()),
                                                 plugins: [MoyaLoggingPlugin()])
    private override init() {}
}

extension HomeAPI{
    public func getTotalPet(familyID: String ,completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.getTotalPet(familyID: familyID)) { (result) in
            self.disposeNetwork(result,
                                dataModel: [HomePetResult].self,
                                completion: completion)
        }
    }
    
    func getTotalArchive(petID: String,
                         limit: String,
                         after: Int?,
                         completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.getTotalArchive(familyID: UserDefaultsManager.familyID, petID: petID, limit: limit, after: after)) { (result) in
            self.disposeNetwork(result,
                                dataModel: [HomeArchiveResult].self,
                                completion: completion)
        }
    }
    
    func getDetailPetArchive(recordID: Int,
                             petID: Int,
                             completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.getDetailPetArchive(familyID: UserDefaultsManager.familyID, recordID: recordID, petID: petID)) { (result) in
            self.disposeNetwork(result,
                                dataModel: ArchiveResult.self,
                                completion: completion)
        }
    }
            
    func getNotice(completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.getNotice) { (result) in
            self.disposeNetwork(result, dataModel: [HomeNoticeResult].self, completion: completion)
        }
    }
    
    func postComment(recordID: String,
                     comment: String,
                     completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.postComment(recordID: recordID, comment: comment)) { (result) in
            self.disposeNetwork(result, dataModel: [CommentResult].self, completion: completion)
        }
    }
    
    func postEmojiComment(recordID: String,
                          emojiID: Int,
                          completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.postEmojiComment(recordID: recordID, emojiID: emojiID)) { (result) in
            self.disposeNetwork(result, dataModel: [CommentResult].self, completion: completion)
        }
    }
}


