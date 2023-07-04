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
    
    
    func updateNextButtonState(button: inout Bool) {
        if (missionData[index].image != defaultImage && missionData[index].content != placeHolderText ) {
            button = true
        }
        else {
            button = false
        }
        
    }
    
    func updateContentTextView(index: Int, contentText: String) {
        if contentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("yes")
            missionData[index].content = self.placeHolderText
            missionData[index].textColor = .zoocGray1
        } else {
            missionData[index].content = contentText
            missionData[index].textColor = .zoocDarkGray1
        }
    }
}
