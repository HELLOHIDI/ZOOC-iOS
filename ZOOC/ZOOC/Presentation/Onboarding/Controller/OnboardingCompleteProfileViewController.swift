//
//  OnboardingCompleteProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class OnboardingCompleteProfileViewController: UIViewController{
    
    //MARK: - Properties
    
    private let onboardingCompleteProfileView = OnboardingCompleteProfileView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = onboardingCompleteProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
        
        style()
    }
    
    //MARK: - Custom Method
    
    func target() {
        onboardingCompleteProfileView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        onboardingCompleteProfileView.getCodeButton.addTarget(self, action: #selector(getCodeButtonDidTap), for: .touchUpInside)
        onboardingCompleteProfileView.notGetCodeButton.addTarget(self, action: #selector(notGetCodeButtonDidTap), for: .touchUpInside)
    }
    
    func style() {
        updateCompleteProfileView()
    }
    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func notGetCodeButtonDidTap() {
        pushToRegisterPetView()
    }
    
    @objc private func getCodeButtonDidTap() {
        pushToParticipateCompletedView()
    }
}

private extension OnboardingCompleteProfileViewController {
    func updateCompleteProfileView() {
        
        UIView.animate(withDuration: 1, delay: 1) {
            self.onboardingCompleteProfileView.completeProfileLabel.alpha = 0.4
            self.onboardingCompleteProfileView.completeProfileSubLabel.alpha = 1
            self.onboardingCompleteProfileView.completeImage.alpha = 1
            self.onboardingCompleteProfileView.getCodeButton.alpha = 1
            self.onboardingCompleteProfileView.notGetCodeButton.alpha = 1
        }
    }
    
    func pushToParticipateCompletedView() {
        let onboardingParticipateViewController = OnboardingJoinFamilyViewController()
        self.navigationController?.pushViewController(onboardingParticipateViewController, animated: true)
    }
    
    func pushToRegisterPetView() {
        let onboardingParticipateViewController = OnboardingRegisterPetViewController(onboardingPetRegisterViewModel: OnboardingPetRegisterViewModel())
        self.navigationController?.pushViewController(onboardingParticipateViewController, animated: true)
    }
}
