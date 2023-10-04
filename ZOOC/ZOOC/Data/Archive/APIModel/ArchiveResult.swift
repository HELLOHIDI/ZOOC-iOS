//
//  HomeDetailArchiveResult.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/12.
//

import Foundation

struct ArchiveResult: Codable {
    let leftID, rightID: Int?
    let record: RecordResult
    let comments: [CommentResult]

    enum CodingKeys: String, CodingKey {
        case leftID = "leftId"
        case rightID = "rightId"
        case record, comments
    }
    
    init(leftID: Int? = nil,
         rightID: Int? = nil,
         record: RecordResult = .init() ,
         comments: [CommentResult] = []) {
        self.leftID = leftID
        self.rightID = rightID
        self.record = record
        self.comments = comments
    }
}

// MARK: - Comment

struct CommentResult: Codable {
    let commentId: Int
    let writerId: Int
    let isEmoji: Bool
    let nickName: String
    let photo: String?
    let content: String?
    let emoji: Int?
    let date: String
    let isMyComment: Bool
}

