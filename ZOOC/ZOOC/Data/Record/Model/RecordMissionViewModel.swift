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
    
    
    func updateNextButtonState(button: inout Bool, color: inout UIColor?) {
        guard let image = missionData[index].image, let content = missionData[index].content else { return }
        button = true
        color = .zoocGradientGreen
    }
}
