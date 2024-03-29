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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.onboardingCompleteProfileView.completeProfileLabel.textColor = .zoocGray1
            self.onboardingCompleteProfileView.completeProfileSubLabel.isHidden = false
            self.onboardingCompleteProfileView.completeImage.isHidden = false
            self.onboardingCompleteProfileView.getCodeButton.isHidden = false
            self.onboardingCompleteProfileView.notGetCodeButton.isHidden = false
        }
    }
    
    func pushToParticipateCompletedView() {
        let onboardingParticipateViewController = OnboardingParticipateViewController()
        self.navigationController?.pushViewController(onboardingParticipateViewController, animated: true)
    }
    
    func pushToRegisterPetView() {
        let onboardingParticipateViewController = OnboardingRegisterPetViewController(onboardingPetRegisterViewModel: OnboardingPetRegisterViewModel())
        self.navigationController?.pushViewController(onboardingParticipateViewController, animated: true)
    }
}
