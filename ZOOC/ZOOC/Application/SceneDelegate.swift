//
//  SceneDelegate.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//
import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print(#function)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        autoLogin(window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("👶🏻 \(#function)")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("👶🏻 \(#function)")
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("👶🏻 \(#function)")
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


extension SceneDelegate {
    
    private func autoLogin(_ window: UIWindow?) {
        guard !User.shared.zoocAccessToken.isEmpty else {
            print("📌 DB에 AccessToken 값이 없습니다. 온보딩을 시작합니다.")
            autoLoginFail(window)
            return
        }
        requestFamilyAPI(window)
    }
    
    
    
    private func requestFamilyAPI(_ window: UIWindow?) {
        OnboardingAPI.shared.getFamily { result in
            switch result{
                
            case .success(let data):
                guard let data = data as? [OnboardingFamilyResult] else { return }
                if data.count != 0 {
                    let familyID = String(data[0].id)
                    User.shared.familyID = familyID
                    self.autoLoginSuccess(window)
                } else {
                    self.autoLoginFail(window)
                }
            default:
                print("자동로그인 실패")
                self.autoLoginFail(window)
            }
        }
    }
    
    private func autoLoginSuccess(_ window: UIWindow?) {
        print(#function)
        requestFCMTokenAPI(window)
    }
    
    private func autoLoginFail (_ window: UIWindow?) {
        let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
        onboardingNVC.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = onboardingNVC
        self.window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
    
    private func requestFCMTokenAPI(_ window: UIWindow?) {
        OnboardingAPI.shared.patchFCMToken(fcmToken: User.shared.fcmToken) { result in
            let mainVC = ZoocTabBarController()
            window?.rootViewController = mainVC
            self.window?.backgroundColor = .white
            window?.makeKeyAndVisible()
        }
    }

    
}
