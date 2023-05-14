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
            gradientLayer?.colors = gradientColors
        }
    }
    //MARK: - UI Components
    
    private var gradientLayer: CAGradientLayer?
    private var shadowLayer: CALayer?
    
    
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        self.gradientColors = [activeColorTop, activeColorBottom]
        
        super.init(frame: frame)
        style()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureLayers(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func style() {
        setTitleColor(.zoocWhite1, for: .normal)
        titleLabel?.font = .zoocSubhead1
        titleLabel?.textAlignment = .center
    }
    
    private func configureLayers(_ rect: CGRect) {
          if shadowLayer == nil {
              let shadowLayer = CALayer()
              shadowLayer.applySketchShadow(color: .init(r: 23, g: 143, b: 66),
                                            alpha: 0.2,
                                            x: 5,
                                            y: 5,
                                            blur: 18,
                                            spread: 0)
              layer.insertSublayer(shadowLayer, at: 0)
              self.shadowLayer = shadowLayer
          }
        
        if gradientLayer == nil {
            let layer = CAGradientLayer()
            layer.frame = rect
            layer.masksToBounds = true
            layer.startPoint = CGPoint(x: 0.5, y: 0.0)
            layer.endPoint = CGPoint(x: 0.5, y: 1.0)
            layer.cornerRadius = rect.height / 2
            layer.colors = gradientColors
            
            self.layer.insertSublayer(layer, at: 1)
            self.gradientLayer = layer
        }
      }
}
