//
//  SplashViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/16.
//

import UIKit

import FirebaseRemoteConfig

final class SplashViewController: UIViewController {
    
    //MARK: - Properties
    
    private var version: VersionState = .latestVersion {
        didSet{
            disposeVersion()
        }
    }
    
    private let userInfo: [AnyHashable: Any]?
    
    //MARK: - UI Components
    
    private let noiseImageView = UIImageView(image: Image.noise)
    private let imageView = UIImageView(image: Image.logoSymbol)
    
    //MARK: - Life Cycle
    
    init(userInfo: [AnyHashable: Any]? = nil) {
        self.userInfo = userInfo

        super.init(nibName: nil, bundle: nil)

    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkVersion()
    }
    
    //MARK: - UI & Layout
    
    func style() {
        view.backgroundColor = .zoocMainGreen
        
        noiseImageView.alpha = 0.4
        noiseImageView.contentMode = .scaleAspectFill
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func hierarchy() {
        view.addSubviews(noiseImageView, imageView)
    }
    
    private func layout() {
        noiseImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
    }
    
    private func checkUser() {
        if let userInfo {
            configureInvitation(with: userInfo)
        } else {
            autoLogin()
        }
    }
    
    private func autoLogin() {
        guard !UserDefaultsManager.zoocAccessToken.isEmpty else {
            print("📌 DB에 AccessToken 값이 없습니다. 온보딩을 시작합니다.")
            autoLoginFail()
            return
        }
        requestFamilyAPI()
    }
    
    private func disposeVersion() {
        switch version {

        case .latestVersion:
            checkUser()
        default:
            DispatchQueue.main.async {
                let alertVC = VersionAlertViewController(self.version)
                alertVC.delegate = self
                alertVC.modalPresentationStyle = .overFullScreen
                self.present(alertVC, animated: false)
            }
           
        }
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
        DispatchQueue.main.async {
            let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
            onboardingNVC.setNavigationBarHidden(true, animated: true)
            
            UIApplication.shared.changeRootViewController(onboardingNVC)
        }
    }
    
    private func requestFCMTokenAPI() {
        OnboardingAPI.shared.patchFCMToken(fcmToken: UserDefaultsManager.fcmToken) { result in
            let mainVC = ZoocTabBarController()
            UIApplication.shared.changeRootViewController(mainVC)
        }
    }
    
    func configureInvitation(with userInfo: [AnyHashable: Any]){
        
        guard let apsValue = userInfo["aps"] as? [String : AnyObject] else { return }
        guard let alertValue = apsValue["data"] as? [String : Any] else { return }
        
        guard let familyID = alertValue["familyId"] as? Int,
              let recordID = alertValue["recordId"] as? Int,
              let petID = alertValue["petId"] as? Int else {
            print("가드에막혔누")
            return }
        
        UserDefaultsManager.familyID = String(familyID)
        let archiveModel = ArchiveModel(recordID: recordID, petID: petID)
        let archiveVC = ArchiveViewController(archiveModel, scrollDown: true)
        archiveVC.modalPresentationStyle = .fullScreen
        
        let tabVC = ZoocTabBarController()
        
        
        UIApplication.shared.changeRootViewController(tabVC)
        
        tabVC.present(archiveVC, animated: true)
    }
    
    
}

extension SplashViewController {
    private func checkVersion() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings =  RemoteConfigSettings()
        
        
        let localVersion: AppVersion = Device.getCurrentVersion().transform()
        
        
        remoteConfig.fetch() { [weak self] status, error in
            
            if status == .success {
                // 2. activate (컨피그 값 가져오기)
                remoteConfig.activate() { [weak self] changed, error in
                    guard let latestVersion = remoteConfig["latestVersion"].stringValue,
                          let minVersion = remoteConfig["minVersion"].stringValue else {
                        return
                    }
                    
                    let remoteLatestVersion = latestVersion.transform()
                    let remoteMinVersion = minVersion.transform()
                    
                    guard localVersion >= remoteMinVersion else {
                        self?.version = .mustUpdate
                        return
                    }
                    
                    if localVersion < remoteLatestVersion {
                        self?.version = .recommendUpdate
                    } else {
                        self?.version = .latestVersion
                    }
                }
            } else {
                return
            }
        }
    }
}

//MARK: - VersionAlertViewControllerDelegate
extension SplashViewController: VersionAlertViewControllerDelegate {
    
    func updateButtonDidTap() {
        switch version {
        case .mustUpdate:
            checkVersion()
        default:
            checkUser()
        }
    }
    
    func exitButtonDidTap() {
        checkUser()
    }
}
