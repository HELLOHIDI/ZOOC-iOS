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
    
    static let mailMissionAdviceBody = """
                                        추가하고 싶은 미션을 말씀해주세요.
                                        
                                        <예시>
                                        이런 미션이 있었으면 좋겠어요
                                        
                                        -------------------
                                        
                                        Device Model : \(Device.getDeviceIdentifier())
                                        Device OS : \(Device.osVersion)
                                        App Version : \(Device.getCurrentVersion())
                                        
                                        -------------------
                                        """
    
    
}
