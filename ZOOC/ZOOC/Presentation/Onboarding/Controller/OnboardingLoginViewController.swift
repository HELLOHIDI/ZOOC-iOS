//
//  OnboardingLoginViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

final class OnboardingLoginViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let onboardingLoginView = OnboardingLoginView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = onboardingLoginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        target()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - Custom Method
    
    private func target() {
        onboardingLoginView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
        onboardingLoginView.goHomeButton.addTarget(self, action: #selector(goHomeButtonDidTap), for: .touchUpInside)
        onboardingLoginView.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
    }
    
    private func pushToAgreementView() {
        let agreementViewController = OnboardingAgreementViewController(onboardingAgreementViewModel: OnboardingAgreementViewModel())
        self.navigationController?.pushViewController(agreementViewController, animated: true)
    }
    
    //MARK: - Action Method
    
    @objc func kakaoLoginButtonDidTap() {
        requestKakaoSocialLoginAPI()
    }
    
    @objc func appleLoginButtonDidTap() {
        requestAppleSocialLoginAPI()
    }
    
    @objc func goHomeButtonDidTap(){
        UserDefaultsManager.zoocAccessToken = "Test용 AccessToken 입력 공간"
        self.requestFamilyAPI()
    }
}

//MARK: - API Method

private extension OnboardingLoginViewController {
    private func requestKakaoSocialLoginAPI() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                guard let oauthToken = oauthToken else {
                    guard let error = error else { return }
                    print(error)
                    return
                }
                self.requestZOOCKaKaoLoginAPI(oauthToken)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                guard let oauthToken = oauthToken else {
                    guard let error = error else { return }
                    print(error)
                    return
                }
                
                self.requestZOOCKaKaoLoginAPI(oauthToken)
            }
        }
    }
    
    private func requestZOOCKaKaoLoginAPI(_ oauthToken: OAuthToken) {
        OnboardingAPI.shared.postKakaoSocialLogin(accessToken: "Bearer \(oauthToken.accessToken)") { result in
            guard let result = self.validateResult(result) as? OnboardingJWTTokenResult else { return }
            UserDefaultsManager.zoocAccessToken = result.accessToken
            UserDefaultsManager.zoocRefreshToken = result.refreshToken
            
            if result.isExistedUser{
                self.requestFamilyAPI()
            } else {
                self.pushToAgreementView()
            }
        }
    }
    
    private func requestAppleSocialLoginAPI() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func requestZOOCAppleSocialLoginAPI(_ identityTokenString: String) {
        OnboardingAPI.shared.postAppleSocialLogin(request: OnboardingAppleSocialLoginRequest(identityTokenString: identityTokenString)) { result in
            guard let result = self.validateResult(result) as? OnboardingJWTTokenResult else { return }
            UserDefaultsManager.zoocAccessToken = result.accessToken
            UserDefaultsManager.zoocRefreshToken = result.refreshToken
            print("🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏")
            if result.isExistedUser{
                self.requestFamilyAPI()
            } else {
                self.pushToAgreementView()
            }
            
        }
    }
    
    private func requestFamilyAPI() {
        OnboardingAPI.shared.getFamily { result in
            guard let result = self.validateResult(result) as? [OnboardingFamilyResult] else { return }
            
            if result.count != 0 {
                let familyID = String(result[0].id)
                UserDefaultsManager.familyID = familyID
                self.requestFCMTokenAPI()
            } else {
                self.pushToAgreementView()
            }
        }
    }
    
    private func requestFCMTokenAPI() {
        OnboardingAPI.shared.patchFCMToken(fcmToken: UserDefaultsManager.fcmToken) { result in
            switch result {
            case .success:
                UIApplication.shared.changeRootViewController(ZoocTabBarController())
            default:
                self.showToast("FCM토큰을 재발급이 필요합니다.", type: .bad)
                
                UIApplication.shared.changeRootViewController(ZoocTabBarController())
            }
            
            
        }
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
                
                
                requestZOOCAppleSocialLoginAPI(identityTokenString)
                print("identityTokenString: \(identityTokenString)")
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

