//
//  RecordMissionViewModle.swift
//  ZOOC
//
//  Created by 류희재 on 2023/05/12.
//

import UIKit

final class RecordMissionViewModel {
    
    var missionData: [RecordModel] = []
    var index: Int = 0
    var tag: Int = 0
    var defaultImage: UIImage = Image.gallery
    var placeHolderText: String = "오늘 어떤 일이 있었는지 공유해보세요"
    
    
    func updateNextButtonState(button: inout Bool, color: inout UIColor?) {
        if (missionData[index].image != defaultImage && missionData[index].content != placeHolderText ) {
            button = true
            color = .zoocGradientGreen
        }
        else {
            button = false
            color = .zoocGray1
        }
        
    }
    
    func updateContentTextView(placeholderText: inout String) {
        for mission in missionData {
            if let content = mission.content {
                placeholderText = "오늘 있었던 일을 얘기해줘"
            }
        }
    }
}
