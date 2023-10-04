//
//  OnboardingParticipateViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class OnboardingJoinFamilyViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let rootView = OnboardingJoinFamilyView.init(onboardingState: .processCodeReceived)
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        target()
    }
    
    //MARK: - Custom Method
    
    func register() {
        rootView.familyCodeTextField.delegate = self
    }
    
    func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonDidTap() {
        requestJoinFamilyAPI()
    }
}

extension OnboardingJoinFamilyViewController {
    private func requestJoinFamilyAPI() {
        guard let code = rootView.familyCodeTextField.text else { return }
        let param = OnboardingJoinFamilyRequest(code: code)
        OnboardingAPI.shared.postJoinFamily(requset: param) { result in
            
            switch result {
            case .success(let data):
                guard let result = data as? OnboardingJoinFamilyResult else { return }
                UserDefaultsManager.familyID = String(result.familyID)
                self.requestFCMTokenAPI()
            case .requestErr(let msg):
                self.showToast(msg, type: .bad)
            default:
                self.validateResult(result)
            }
        }
    }
    
    private func requestFCMTokenAPI() {
        OnboardingAPI.shared.patchFCMToken(fcmToken: UserDefaultsManager.fcmToken) { result in
            self.pushToJoinCompletedViewController()
            
        }
    }
    
    func pushToJoinCompletedViewController() {
        let joinCompletedVC = OnboardingJoinFamilyCompletedViewController()
        self.navigationController?.pushViewController(joinCompletedVC, animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension OnboardingJoinFamilyViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.rootView.nextButton.isEnabled = textField.hasText
    }
}
