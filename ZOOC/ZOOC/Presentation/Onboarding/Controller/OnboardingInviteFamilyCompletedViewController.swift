//
//  OnboardingInviteCompletedFamilyViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/10.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingInviteFamilyCompletedViewController: UIViewController{
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingInviteCompletedFamilyView.init(onboardingState: .onboardingSuccess)
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    //MARK: - Custom Method
    
    func bindUI() {
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.startButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.requestFCMTokenAPI()
        }).disposed(by: disposeBag)
    }
    
    
    private func requestFCMTokenAPI() {
        OnboardingAPI.shared.patchFCMToken(fcmToken: UserDefaultsManager.fcmToken) { result in
            switch result {
            case .success(_):
                UIApplication.shared.changeRootViewController(ZoocTabBarController())
            default:
                print("FCM 토큰 갱신 API 확인해보세요e")
                UIApplication.shared.changeRootViewController(ZoocTabBarController())
            }
            
        }
    }
}
