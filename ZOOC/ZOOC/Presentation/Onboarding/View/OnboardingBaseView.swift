//
//  OnboardingBaseView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/03/13.
//

import UIKit

import SnapKit
import Then

enum OnboardingState {
    case makeFamily
    case checkReceivedCode
    case processCodeReceived
    case onboardingSuccess
    
    var progressBarIsHidden: Bool {
        switch self {
        case .makeFamily:
            return true
        default:
            return false
        }
    }
    
    var firstProgressBarBackgroundColor: UIColor {
        switch self {
        case .makeFamily:
            return .zoocLightGray
        case .checkReceivedCode:
            return .zoocMainGreen
        case .processCodeReceived:
            return .zoocMainGreen
        case .onboardingSuccess:
            return .zoocMainGreen
        }
    }
    
    var secondProgressBarBackgroundColor: UIColor {
        switch self {
        case .makeFamily:
            return .zoocLightGray
        case .checkReceivedCode:
            return .zoocLightGray
        case .processCodeReceived:
            return .zoocMainGreen
        case .onboardingSuccess:
            return .zoocMainGreen
        }
    }
    
    var thirdProgressBarBackgroundColor: UIColor {
        switch self {
        case .makeFamily:
            return .zoocLightGray
        case .checkReceivedCode:
            return .zoocLightGray
        case .processCodeReceived:
            return .zoocLightGray
        case .onboardingSuccess:
            return .zoocMainGreen
        }
    }
}

class OnboardingBaseView: UIView {

    //MARK: - UI Components
    
    public var onboardingState: OnboardingState
    
    public lazy var backButton = UIButton()
    public lazy var firstProgressBar = UIView()
    public lazy var secondProgressBar = UIView()
    public lazy var thirdProgressBar = UIView()

    //MARK: - Life Cycles

    init(onboardingState: OnboardingState) {
        self.onboardingState = onboardingState
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Custom Method

    private func style() {
        self.backgroundColor = .zoocBackgroundGreen

        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }
        
        firstProgressBar.do {
            $0.backgroundColor = onboardingState.firstProgressBarBackgroundColor
            $0.makeCornerRound(radius: 2)
            $0.isHidden = onboardingState.progressBarIsHidden
        }
        
        secondProgressBar.do {
            $0.backgroundColor = onboardingState.secondProgressBarBackgroundColor
            $0.makeCornerRound(radius: 2)
            $0.isHidden = onboardingState.progressBarIsHidden
        }
        
        thirdProgressBar.do {
            $0.backgroundColor = onboardingState.thirdProgressBarBackgroundColor
            $0.makeCornerRound(radius: 2)
            $0.isHidden = onboardingState.progressBarIsHidden
        }
    }
    private func hierarchy() {
        self.addSubviews(
            backButton,
            firstProgressBar,
            secondProgressBar,
            thirdProgressBar
        )
    }

    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(42)
        }
        
        firstProgressBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(self.backButton.snp.bottom).offset(11)
            $0.width.equalTo(106.03)
            $0.height.equalTo(4)
        }
        
        secondProgressBar.snp.makeConstraints {
            $0.leading.equalTo(self.firstProgressBar.snp.trailing).offset(3.96)
            $0.top.equalTo(self.backButton.snp.bottom).offset(11)
            $0.width.equalTo(106.03)
            $0.height.equalTo(4)
            
        }
        thirdProgressBar.snp.makeConstraints {
            $0.leading.equalTo(self.secondProgressBar.snp.trailing).offset(3.96)
            $0.top.equalTo(self.backButton.snp.bottom).offset(11)
            $0.width.equalTo(106.03)
            $0.height.equalTo(4)
            
        }
    }
}
