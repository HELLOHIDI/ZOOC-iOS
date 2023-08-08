//
//  OnboardingChooseFamilyRoleViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/08.
//

import UIKit

import SnapKit
import Then



final class OnboardingChooseRoleViewController: UIViewController{
    
    //MARK: - Properties
    
    private let rootView = OnboardingChooseRoleView()
    private var registerMyProfileData = EditProfileRequest(hasPhoto: false)
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
        
        rootView.nextButton.addTarget(self, action: #selector(chooseFamilyButtonDidTap), for: .touchUpInside)
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc private func textDidChange(_ notification: Notification) {
        guard let textField = notification.object as? UITextField else { return }
        guard let text = textField.text else { return }
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...9:
            textFieldState = .isWritten
        case 10...:
            textFieldState = .isFull
            textField.resignFirstResponder()
            let index = text.index(text.startIndex, offsetBy: 10)
            let newString = text[text.startIndex..<index]
            textField.text = String(newString)
        default:
            textFieldState = .isEmpty
        }

        textFieldState.setTextFieldState(
            textField: rootView.roleTextField,
            underLineView: rootView.textFieldUnderLineView,
            label: nil
        )
    }
    
    @objc private func chooseFamilyButtonDidTap() {
        registerMyProfileData.nickName = rootView.roleTextField.text!
        MyAPI.shared.patchMyProfile(requset: registerMyProfileData) { result in
            //guard let result = self.validateResult(result) as? UserResult else { return }
            self.pushToCompleteProfileView()
        }
    }
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OnboardingChooseRoleViewController {
    func pushToCompleteProfileView() {
        let onboardingCompleteProfileViewController = OnboardingCompleteProfileViewController()
        self.navigationController?.pushViewController(onboardingCompleteProfileViewController, animated: true)
    }
}

