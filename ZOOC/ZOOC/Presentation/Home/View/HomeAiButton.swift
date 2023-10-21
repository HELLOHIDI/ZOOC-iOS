//
//  HomeAIButton.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/19.
//

import UIKit

import Then
import SnapKit

final class HomeAiButton: UIButton {
    
    //MARK: - Properties
    
    private enum Color {
        static var gradientColors = [
            UIColor(r: 66, g: 200, b: 127),
            UIColor(r: 205, g: 238, b: 220),
            UIColor(r: 104, g: 221, b: 153)
        ]
    }
    
    private enum Constants {
        static let gradientLocation = [Int](0..<Color.gradientColors.count)
            .map(Double.init)
            .map { $0 / Double(Color.gradientColors.count) }
            .map(NSNumber.init)
        static let cornerRadius = 12.0
        static let cornerWidth = 2.0
    }
    
    private var timer: Timer?
    
    //MARK: - UI Components
    
    public let aiLogoImageView = UIImageView()
    public let aiLabel = UILabel()
    
    //MARK: - Life Cycle

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.animateBorderGradation()
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    //MARK: - Custom Method
    
    func startAnimation() {
        animateBorderGradation()
    }
    
    func endAnimation() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func style() {
        aiLogoImageView.do {
            $0.image = Image.aiLogo
        }
        
        aiLabel.do {
            $0.text = "우리집 반려동물 프로필 보러가기"
            $0.font = .zoocBody1
            $0.textColor = .zoocGray3
//            $0.asColor(targetString: "AI", color: .zoocMainGreen)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(aiLogoImageView,
                                aiLabel)
    }
    
    private func layout() {
        aiLogoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        
        aiLabel.snp.makeConstraints {
            $0.leading.equalTo(aiLogoImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    private func animateBorderGradation() {
        
        // 1. 경계선에만 색상을 넣기 위해서 CAShapeLayer 인스턴스 생성
            let shape = CAShapeLayer()
            shape.path = UIBezierPath(
                roundedRect: self.bounds.insetBy(
                    dx: Constants.cornerWidth,
                    dy: Constants.cornerWidth),
                cornerRadius: self.layer.cornerRadius
            ).cgPath
            shape.lineWidth = Constants.cornerWidth
            shape.cornerRadius = Constants.cornerRadius
            shape.strokeColor = UIColor.white.cgColor
            shape.fillColor = UIColor.clear.cgColor
        
        // 2. conic 그라데이션 효과를 주기 위해서 CAGradientLayer 인스턴스 생성 후 mask에 CAShapeLayer 대입
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.type = .conic
        gradient.colors = Color.gradientColors.map(\.cgColor) as [Any]
        gradient.locations = Constants.gradientLocation
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = shape
        gradient.cornerRadius = Constants.cornerRadius
        self.layer.addSublayer(gradient)
        
        // 3. 매 0.5초마다 마치 circular queue처럼 색상을 번갈아서 바뀌도록 구현
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            gradient.removeAnimation(forKey: "myAnimation")
            let previous = Color.gradientColors.map(\.cgColor)
            let last = Color.gradientColors.removeLast()
            Color.gradientColors.insert(last, at: 0)
            let lastColors = Color.gradientColors.map(\.cgColor)
            
            let colorsAnimation = CABasicAnimation(keyPath: "colors")
            colorsAnimation.fromValue = previous
            colorsAnimation.toValue = lastColors
            colorsAnimation.repeatCount = 1
            colorsAnimation.duration = 0.5
            colorsAnimation.isRemovedOnCompletion = false
            colorsAnimation.fillMode = .both
            gradient.add(colorsAnimation, forKey: "myAnimation")
        }
    }
}


