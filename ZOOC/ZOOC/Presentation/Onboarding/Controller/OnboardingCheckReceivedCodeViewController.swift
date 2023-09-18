//
//  OnboardingCompleteProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class OnboardingCheckReceivedCodeViewController: BaseViewController{
    
    //MARK: - Properties
    
    private let rootView = OnboardingCheckReceivedCodeView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
    }
    
    //MARK: - Custom Method
    
    func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.getCodeButton.addTarget(self, action: #selector(getCodeButtonDidTap), for: .touchUpInside)
        rootView.notGetCodeButton.addTarget(self, action: #selector(notGetCodeButtonDidTap), for: .touchUpInside)
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

private extension OnboardingCheckReceivedCodeViewController {
    private func requestMakeFamilyAPI() {
        OnboardingAPI.shared.postMakeFamily() { result in
            guard let result = self.validateResult(result) as? OnboardingMakeFamilyResult else { return }
            UserDefaultsManager.familyID = String(result.familyId)
            
            self.pushToInviteFamilyView()
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
