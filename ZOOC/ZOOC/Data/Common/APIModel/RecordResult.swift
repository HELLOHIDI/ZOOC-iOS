//
//  RecordResult.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/12.
//

import Foundation

struct RecordResult: Codable{
    let id: Int
    let photo: String
    let content: String?
    let date: String
    let writerPhoto: String?
    let writerName: String
    let isMyRecord: Bool
    
    init(
        id: Int = Int(),
        photo: String = String(),
        content: String? = nil,
        date: String = String(),
        writerPhoto: String? = nil,
        writerName: String = String(),
        isMyRecord: Bool = Bool()
    ) { 
        self.id = id
        self.photo = photo
        self.content = content
        self.date = date
        self.writerPhoto = writerPhoto
        self.writerName = writerName
        self.isMyRecord = isMyRecord
    }

}
