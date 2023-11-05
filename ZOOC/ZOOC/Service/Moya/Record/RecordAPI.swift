//
//  HomeAPI.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit
import Moya

class RecordAPI: BaseAPI {
    static let shared = RecordAPI()
    var recordProvider = MoyaProvider<RecordService>(session: Session(interceptor: ZoocInterceptor()),
                                                     plugins: [MoyaLoggingPlugin()])
    private override init() {}
}

extension RecordAPI{
    func getTotalPet(completion: @escaping (NetworkResult<Any>) -> Void) {
        recordProvider.request(.getTotalPet(familyID: UserDefaultsManager.familyID)) { (result) in
            self.disposeNetwork(result,
                                dataModel: [PetResult].self,
                                completion: completion)
        }
    }
    
    func postRecord(photo: UIImage, content: String?, pets: [Int], completion: @escaping (NetworkResult<Any>) -> Void){
        recordProvider.request(.postRecord(familyID: UserDefaultsManager.familyID,
                                           photo: photo,
                                           content: content,
                                           pets: pets)) { result in
            self.disposeNetwork(result,
                                dataModel: VoidResult.self,
                                completion: completion)
        }
    }
}


