//
//  ZoocRequiredInputLabel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/08.
//

import UIKit

class ZoocRequiredInputLabel: UILabel {

    private let isRequired = true
    
    convenience init(text: String) {
        self.init()
        style(text)
    }
    
    func style(_ text: String) {
        self.text = "\(text) *"
        self.font = .zoocBody2
        self.textColor = .zoocGray2
        setAttributeLabel(targetString: ["*"], color: .zoocSubGreen, font: UIFont(name: "Pretendard-Bold", size: 12)!, baseLineOffset: 5)
    }
    
}

