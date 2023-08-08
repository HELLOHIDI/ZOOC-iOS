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
    private var viewModel: OnboardingChooseRoleViewModel
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingChooseRoleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        delegate()
        target()
        
    }
    
    //MARK: - Custom Method
    
    func bind() {
        viewModel.ableToEditProfile.observe(on: self) { [weak self] isEnabled in
            self?.rootView.nextButton.isEnabled = isEnabled
        }
        
        viewModel.textFieldState.observe(on: self) { [weak self] state in
            self?.updateTextFieldUI(state)
        }
        
        viewModel.editCompletedOutput.observe(on: self) { [weak self] isSuccess in
            guard let isSuccess else { return }
            if isSuccess {
                self?.pushToCompleteProfileView()
            } else {
                self?.presentBottomAlert("다시 시도해주세요")
            }
        }
    }
    
    func delegate() {
        rootView.roleTextField.editDelegate = self
    }
    
    func target() {
        rootView.nextButton.addTarget(self, action: #selector(chooseFamilyButtonDidTap), for: .touchUpInside)
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method

    
    @objc private func chooseFamilyButtonDidTap() {
        viewModel.patchMyProfile()
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
    
    private func updateTextFieldUI(_ textFieldState: BaseTextFieldState) {
        rootView.textFieldUnderLineView.backgroundColor = textFieldState.underLineColor
        rootView.roleTextField.textColor = textFieldState.textColor
    }
}

extension OnboardingChooseRoleViewController: MyTextFieldDelegate {
    func myTextFieldTextDidChange(_ textFieldType: MyEditTextField.TextFieldType, text: String) {
        self.viewModel.nameTextFieldDidChangeEvent(text)

        if viewModel.isTextCountExceeded(for: textFieldType) {
            let fixedText = text.substring(from: 0, to:9)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.rootView.roleTextField.text = fixedText
            }
        }
    }
}
