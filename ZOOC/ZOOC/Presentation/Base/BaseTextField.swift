//
//  BaseTextField.swift
//  ZOOC
//
//  Created by 장석우 on 2023/02/28.
//

import UIKit

class BaseTextField: UITextField {
    
    enum TextFieldType {
        case profile
        case pet
        
        var limit: Int {
            switch self {
            case .profile: return 10
            case .pet: return 4
            }
        }
    }
    
    public var textFieldType: TextFieldType
    
    init(viewType: TextFieldType) {
        self.textFieldType = viewType
        super.init(frame: .zero)
        
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)

        /// 모든 방향에 20만큼 터치 영역 증가
        /// dx: x축이 dx만큼 증가 (음수여야 증가)
        let touchArea = bounds.insetBy(dx: -20, dy: -30)
        return touchArea.contains(point)
    }

    func configure() {}
    func bind() {}
    
    func textFieldDidChange() {
        
    }
}
