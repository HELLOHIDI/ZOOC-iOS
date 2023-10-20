//
//  EventProgress.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/20.
//

import Foundation

enum EventProgress: String {
    case notApplied = "NOT_APPLIED"
    case inProgress = "IN_PROGRESS"
    case done = "DONE"
    
    var imageURL: String {
        switch self {
        case .notApplied:
            //return "https://ibb.co/hd0jBhx"
            return "https://zooc-bucket.s3.ap-northeast-2.amazonaws.com/test/server/images/1691759607477_image.jpeg"
        case .inProgress:
            return "https://ibb.co/vcXpxG9"
        case .done:
            return "https://ibb.co/yW2VxB0"
        }
    }
    
    
}
