//
//  RecordMissonRequest.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/03/13.
//

import Foundation

struct RecordMissionRequest: Codable {
    let content: String
    let file: Data
    let pet: [Int]
}
