//
//  OnboardingLoginViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import RxSwift
import RxCocoa

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

final class OnboardingLoginViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: OnboardingLoginViewModel
    private let disposeBag = DisposeBag()
    
    private let appleIdentityTokenReceivedSubject = PublishSubject<String>()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingLoginView()
    
    private var authorizationController: ASAuthorizationController {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        return authorizationController
    }
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingLoginViewModel) {
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
        
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.appleLoginButton.rx.controlEvent(.touchUpInside).subscribe(with: self, onNext: { owner, _ in
            owner.authorizationController.performRequests()
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = OnboardingLoginViewModel.Input(
            kakaoLoginButtonDidTapEvent: rootView.kakaoLoginButton.rx.tap.asObservable(),
            receiveAppleIdentityTokenEvent: appleIdentityTokenReceivedSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.isExistedUser
            .filter { !$0 }
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, _ in
                owner.pushToAgreementView()
            }).disposed(by: disposeBag)
        
        output.loginSucceeded
            .filter { !$0 }
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, _ in
                owner.showToast("로그인 과정 중 문제가 발생했습니다", type: .bad)
            }).disposed(by: disposeBag)
        
        output.autoLoginSucceeded
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, autoLoginSucceded in
                if !autoLoginSucceded { owner.showToast("FCM토큰을 재발급이 필요합니다.", type: .bad) }
                UIApplication.shared.changeRootViewController(ZoocTabBarController())
            }).disposed(by: disposeBag)
    }
}


//MARK: - API Method

private extension OnboardingLoginViewController {
    func pushToAgreementView() {
        let agreementVC = OnboardingAgreementViewController()
        self.navigationController?.pushViewController(agreementVC, animated: true)
    }
}


//MARK: - ASAuthorizationControllerDelegate

extension OnboardingLoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let identityToken = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityToken, encoding: .utf8) {
                appleIdentityTokenReceivedSubject.onNext(identityTokenString)
            }
        default:
            break
        }
    }
}

