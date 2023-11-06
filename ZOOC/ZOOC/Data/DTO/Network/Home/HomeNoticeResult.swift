//
//  HomeAlarmResult.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/13.
//

import Foundation

// MARK: - HomeAlarmResult

struct HomeNoticeResult: Codable {
    let recordID: Int
    let petIDs: [Int]
    let writer: HomeNoticeWriter
    let createdTime: String
    
    enum CodingKeys: String, CodingKey {
        case recordID = "record_id"
        case petIDs = "pet_ids"
        case writer
        case createdTime = "created_time"
    }
}

// MARK: - HomeAlarmWriter

struct HomeNoticeWriter: Codable {
    let id: Int
    var nickName: String
    var photo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nickName = "nick_name"
        case photo
    }
}



