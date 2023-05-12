//
//  RecordMissionListModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/05/11.
//

import Foundation
import UIKit

struct RecordMissionResult: Codable {
    let id: Int
    let missionContent: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case missionContent = "mission_content"
    }
}
