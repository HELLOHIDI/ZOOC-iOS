//
//  GradinetButton.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/14.
//

import UIKit

final class ZoocGradientButton: UIButton {
    
    //MARK: - Properties
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                gradientColors = [activeColorTop, activeColorBottom]
            } else {
                gradientColors = [inActiveColor, inActiveColor]
            }
        }
    }
    
    var inActiveColor: CGColor = .zoocGray1
    var activeColorTop: CGColor = .zoocGradientGreenFirst
    var activeColorBottom: CGColor = .zoocGradientGreenLast
    
    private var gradientColors: [CGColor] {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }
    //MARK: - UI Components
    
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    
    private
    
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        self.gradientColors = [activeColorTop, activeColorBottom]
        
        super.init(frame: frame)
        
        gradientLayer.colors = gradientColors
        self.layer.addSublayer(gradientLayer)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        self.makeShadow(color: .zoocGray1,
                        offset: CGSize(width: 0, height: 5),
                        radius: 4,
                        opacity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
