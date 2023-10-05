//
//  OnboardingParticipateCompletedViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingJoinFamilyCompletedViewController: BaseViewController{
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingJoinFamilyCompletedView.init(onboardingState: .processCodeReceived)
    
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
        
        rootView.startButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.pushToInviteFamilyCompleteView()
        }).disposed(by: disposeBag)
    }
}

extension OnboardingJoinFamilyCompletedViewController {
    private func pushToInviteFamilyCompleteView(){
        let inviteFamilyCompletedVC = OnboardingInviteFamilyCompletedViewController()
        self.navigationController?.pushViewController(inviteFamilyCompletedVC, animated: true)
    }
}
