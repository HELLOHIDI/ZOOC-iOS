//
//  GradinetButton.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/14.
//

import UIKit

final class GradientButton: UIButton {
    
    //MARK: - Properties
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                gradientColors = [activeColorTop, activeColorBottom]
            } else {
                gradientColors = [inActiveColor]
            }
        }
    }
    
    //MARK: - UI Components
    
    var inActiveColor: CGColor = .zoocGray1
    var activeColorTop: CGColor = .zoocGradientGreenFirst
    var activeColorBottom: CGColor = .zoocGradientGreenLast
    
    private var gradientColors: [CGColor] {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }
    
    private lazy var gradientLayer : CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = gradientColors
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return
    }()
    
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer ,at: 0)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
