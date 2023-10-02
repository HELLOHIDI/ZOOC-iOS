//
//  TextLiteral.swift
//  ZOOC
//
//  Created by 장석우 on 2023/07/04.
//

import Foundation

struct TextLiteral {
    
    static let mailInquiryBody = """
                                 1. 문의 내용:
                                 
                                 2. 유저명:
                                 
                                 
                                 -------------------
                                 
                                 Device Model : \(Device.getDeviceIdentifier())
                                 Device OS : \(Device.osVersion)
                                 App Version : \(Device.getCurrentVersion())
                                 - 문의 관련은 스크린 샷을 첨부하시면 더욱 빠르게 확인할 수 있습니다.
                                 -------------------
                                 """
    
    static func invitedMessage(invitedCode: String) -> String {
        return """
               [ZOOC]
               
               ‘ZOOC’에 우리 가족을 초대하고 있어요!
               지금 바로 아래 초대 코드를 입력하고 가족과 추억을 공유하세요!
               
               초대코드 : \(invitedCode)
               
               \(ExternalURL.zoocAppStoreKR())
               """
    }
    
    static func mailRecordReportBody(recordID: Int) -> String {
        
        return """
                게시글 ID: \(recordID)
                -------------------
                
                1. 신고사유:
                
                -------------------
                
                Device Model : \(Device.getDeviceIdentifier())
                Device OS : \(Device.osVersion)
                App Version : \(Device.getCurrentVersion())
                - 신고 관련은 스크린 샷을 첨부하시면 더욱 빠르게 확인할 수 있습니다.
                -------------------
                """
    }
    
    static func mailCommentReportBody(commentID: Int) -> String {
        return """
                댓글 ID: \(commentID)
                -------------------
                
                1. 신고사유:
                
                -------------------
                
                Device Model : \(Device.getDeviceIdentifier())
                Device OS : \(Device.osVersion)
                App Version : \(Device.getCurrentVersion())
                - 신고 관련은 스크린 샷을 첨부하시면 더욱 빠르게 확인할 수 있습니다.
                -------------------
                """
    }
    
    static let recordPlaceHolderText = """
                                        ex) 2023년 2월 30일
                                        가족에게 어떤 순간이었는지 남겨주세요
                                        """
}
