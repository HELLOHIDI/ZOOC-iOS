//
//  OnboardingReInviteFamilyViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/10.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingReInviteFamilyViewController: UIViewController{
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingReInviteFamilyView.init(onboardingState: .processCodeReceived)
    
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
        
        rootView.inviteButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.pushToInviteCompletedFamilyView()
        }).disposed(by: disposeBag)
    }
}

private extension OnboardingReInviteFamilyViewController {
    func pushToInviteCompletedFamilyView() {
        let onboardingInviteCompletedFamilyVC = OnboardingInviteFamilyCompletedViewController()
        self.navigationController?.pushViewController(onboardingInviteCompletedFamilyVC, animated: true)
    }
}
