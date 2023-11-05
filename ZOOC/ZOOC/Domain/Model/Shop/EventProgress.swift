//
//  EventProgress.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/20.
//

import UIKit

enum EventProgress: String {
    case notApplied = "NOT_APPLIED"
    case inProgress = "IN_PROGRESS"
    case done = "DONE"
    
    var imageURL: UIImage {
        switch self {
        case .notApplied:
            return Image.notApplied
        case .inProgress:
            return Image.inProgress
        case .done:
            return Image.done
        }
    }
    
    var ableToClick: Bool {
        switch self {
        case .notApplied:
            return true
        case .inProgress:
            return false
        case .done:
            return false
        }
    }
}
