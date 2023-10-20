//
//  ShopEventResult.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/20.
//

import Foundation

struct ShopEventResult: Codable {
    
    let id: Int
    let startDate: String
    let participants: Int
    let able: Int
    
    enum ShopEventResult: String, CodingKey {
        case id, participants, able
        case startDate = "start_date"
    }
    
}
