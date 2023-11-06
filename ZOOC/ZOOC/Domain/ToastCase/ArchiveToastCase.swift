//
//  ArchiveToastCase.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/04.
//

import Foundation

enum ArchiveToastCase: ToastCase {
    
    case firstPage
    case lastPage
    case deleteArchiveSuccess
    case reportSuccess
    case reportFail
    case deleteCommentSuccess
    case serverFail
    case custom(message: String)
    case unknown
    
    var message: String {
        switch self {
        case .firstPage:
            return "가장 최근 페이지에요"
        case .lastPage:
            return "가장 마지막 페이지에요"
        case .deleteArchiveSuccess:
            return "게시글이 삭제되었어요"
        case .reportSuccess:
            return "신고가 접수되었어요"
        case .reportFail:
            return "신고가 접수되지 않았어요"
        case .deleteCommentSuccess:
            return "댓글이 삭제되었어요"
        case .serverFail:
            return "서버 오류가 발생했어요"
        case .custom(message: let message):
            return message
        case .unknown:
            return "알 수 없는 오류가 발생했어요"
        }
    }
    
    var type: Toast.ToastType {
        switch self {
        case .firstPage:
            return .normal
        case .lastPage:
            return .normal
        case .deleteArchiveSuccess:
            return .bad
        case .reportSuccess:
            return .good
        case .reportFail:
            return .bad
        case .deleteCommentSuccess:
            return .good
        case .serverFail:
            return .bad
        case .custom:
            return .bad
        case .unknown:
            return .bad
        }
    }
    
}
