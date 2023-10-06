//
//  OnboardingWelcomeViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingWelcomeViewController: UIViewController{
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingWelcomeView.init(onboardingState: .makeFamily)
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.nextButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.pushToChooseFamilyRoleView()
        }).disposed(by: disposeBag)
        
        self.rx.viewWillAppear.subscribe(with: self, onNext: { owner, _ in
            owner.updateWelcomeView()
        }).disposed(by: disposeBag)
    }
}

extension OnboardingWelcomeViewController {
    private func updateWelcomeView() {
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.rootView.welcomeLabel.alpha = 0.4
            self.rootView.welcomeSubLabel.alpha = 1
            self.rootView.welcomeImage.alpha = 1
            self.rootView.nextButton.alpha = 1
        }
    }
    
    private func pushToChooseFamilyRoleView() {
        let onboardingCompleteProfileVC = OnboardingCheckReceivedCodeViewController(
            viewModel: OnboardingCheckReceivedCodeViewModel(
                onboardingCheckReceivedCodeUseCase: DefaultOnboardingCheckReceivedCodeUseCase(
                    repository: DefaultOnboardingRepository()
                )
            )
        )
        self.navigationController?.pushViewController(onboardingCompleteProfileVC, animated: true)
    }
}
