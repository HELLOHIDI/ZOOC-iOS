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
        
        let vc = UIViewController()
        vc.view.backgroundColor = .zoocMainGreen
        
//        let navigationController = UINavigationController()
//        let coordinator = MyCoordinator(navigationController: navigationController)
//        coordinator.start()
        
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = vc
        
        self.window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        autoLogin()
    }
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

extension SceneDelegate {
    
    private func autoLogin() {
        guard UserDefaultsManager.zoocAccessToken.isEmpty else {
            print("📌 DB에 AccessToken 값이 없습니다. 온보딩을 시작합니다.")
            autoLoginFail()
            return
        }
        requestFamilyAPI()
    }
    
    
    
    private func requestFamilyAPI() {
        OnboardingAPI.shared.getFamily { result in
            switch result{
                
            case .success(let data):
                guard let data = data as? [OnboardingFamilyResult] else { return }
                if data.count != 0 {
                    let familyID = String(data[0].id)
                    UserDefaultsManager.familyID = familyID
                    self.autoLoginSuccess()
                } else {
                    self.autoLoginFail()
                }
            default:
                print("자동로그인 실패")
                self.autoLoginFail()
            }
        }
    }
    
    private func autoLoginSuccess() {
        print(#function)
        requestFCMTokenAPI()
    }
    
    private func autoLoginFail () {
        let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
        onboardingNVC.setNavigationBarHidden(true, animated: true)
        
        UIApplication.shared.changeRootViewController(onboardingNVC)
    }
    
    private func requestFCMTokenAPI() {
        OnboardingAPI.shared.patchFCMToken(fcmToken: UserDefaultsManager.fcmToken) { result in
            let mainVC = ZoocTabBarController()
            UIApplication.shared.changeRootViewController(mainVC)
        }
    }
    
    
}
