//
//  OnboardingCompleteProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class OnboardingCompleteProfileViewController: BaseViewController{
    
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
        requestMakeFamilyAPI()
    }
    
    @objc private func getCodeButtonDidTap() {
        pushToParticipateCompletedView()
    }
}

private extension OnboardingCompleteProfileViewController {
    private func requestMakeFamilyAPI() {
        OnboardingAPI.shared.postMakeFamily() { result in
            guard let result = self.validateResult(result) as? OnboardingMakeFamilyResult else { return }
            UserDefaultsManager.familyID = String(result.familyId)
            
            self.pushToInviteFamilyView()
        }
    }
    
    func updateCompleteProfileView() {
        UIView.animate(withDuration: 0.5, delay: 0.5) {
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
    
    func pushToInviteFamilyView() {
        let onboardingInviteFamilyViewController = OnboardingInviteFamilyViewController()
        self.navigationController?.pushViewController(onboardingInviteFamilyViewController, animated: true)
    }
}
