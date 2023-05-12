//
//  MissionModel.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/02/03.
//

import Foundation
import UIKit

struct RecordMissionModel {
    var question: String?
    var image: UIImage?
    var content: String?
}

extension RecordMissionModel {
    static func dummy() -> [RecordMissionModel] {
        return [
            RecordMissionModel(question: """
                                        반려동물이 사람처럼 느껴진
                                        순간은 언제인가요?
                                        """),
            RecordMissionModel(question: "반려동물의 가장 웃겼던 자세는 무엇인가요?"),
            RecordMissionModel(question: "자주 찾게 되는 반려동물 사진은 무엇인가요?"),
            RecordMissionModel(question: "반려동물이 내 옆에서 자는 모습을 찍어봐요."),
            RecordMissionModel(question: "반려동물의 제일 꼬질꼬질한 모습을 남겨봐요."),
            RecordMissionModel(question: "가족과 반려동물이 함께 찍은 사진을 기록해봐요"),
        ]
    }
}
