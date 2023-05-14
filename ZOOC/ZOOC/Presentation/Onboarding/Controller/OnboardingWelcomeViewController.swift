//
//  OnboardingWelcomeViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

final class OnboardingWelcomeViewController: UIViewController{
    
    //MARK: - Properties
    
    private let rootView = OnboardingWelcomeView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
        
        style()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateWelcomeView()
    }
    
    //MARK: - Custom Method
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        
    }
    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonDidTap() {
        pushToChooseFamilyRoleView()
    }
}

extension OnboardingWelcomeViewController {
    private func updateWelcomeView() {
        UIView.animate(withDuration: 1, delay: 1) {
            self.rootView.welcomeLabel.alpha = 0.4
            self.rootView.welcomeSubLabel.alpha = 1
            self.rootView.welcomeImage.alpha = 1
            self.rootView.nextButton.alpha = 1
        }
    }
    
    private func pushToChooseFamilyRoleView() {
        let onboardingChooseFamilyRoleViewController = OnboardingChooseRoleViewController()
        self.navigationController?.pushViewController(onboardingChooseFamilyRoleViewController, animated: true)
    }
}
