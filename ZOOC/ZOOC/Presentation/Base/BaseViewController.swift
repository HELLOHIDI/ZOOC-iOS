//
//  BaseViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import Photos
import UIKit

import SafariServices

import SnapKit
import Then

class BaseViewController : UIViewController{
    
    //MARK: - Properties
    
    typealias handler<T> = ((T) -> Void)
    
    public var settingHandler: handler<UIAlertAction> = { _ in 
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
    
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    var viewVelocity = CGPoint(x: 0, y: 0)
    
    //MARK: - UI Components
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    //MARK: - Custom Method
    
    private func setUI(){
        view.backgroundColor = .zoocBackgroundGreen
    }
    
    private func setLayout(){
        
        
    }
    
    func addPanDismissGesture() {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    func presentSafariViewController(_ url: String) {
        guard let url = URL(string: url) else {
            self.showToast("잘못된 URL 입니다.", type: .bad)
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .fullScreen
        self.present(safariViewController, animated: true)
    }
    
    func checkAlbumPermission(completion: @escaping (Bool) -> Void) {
        print(#function)
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status{
            case .authorized:
                completion(true)
            case .denied, .restricted, .notDetermined:
                completion(false)
            default:
                completion(false)
            }
        }
    }
    
    func showAccessDenied() {
        let alert = UIAlertController(title: "갤러리 접근이 거부되었습니다", message: "환경설정에서 설정해주세요", preferredStyle: .alert)
        
        let openSettingsAction = UIAlertAction(
            title: "설정하러 가기",
            style: .default,
            handler: self.settingHandler)
        
        let goBackAction = UIAlertAction(
            title: "나가기",
            style: .destructive
        )
        
        alert.addAction(openSettingsAction)
        alert.addAction(goBackAction)
        
        present(alert, animated: false, completion: nil)
    }
    
    @discardableResult
    func validateResult(_ result: NetworkResult<Any>) -> Any?{
        switch result{
        case .success(let data):
            print("성공했습니다.")
            print(data)
            return data
        case .requestErr(let message):
            break
            //showToast(message, type: .bad)
        case .pathErr:
            showToast("path 혹은 method 오류입니다.", type: .bad)
        case .serverErr:
            
            showToast("서버 내 오류입니다.", type: .bad)
        case .networkFail:
            showToast("네트워크가 불안정합니다.", type: .bad)
        case .decodedErr:
            showToast("디코딩 오류가 발생했습니다.", type: .bad)
        case .authorizationFail(_):
            showToast("인증 오류가 발생했습니다. 다시 로그인해주세요", type: .bad)
        }
        return nil
    }
    
    //MARK: - Keyboard 관련 처리
    
    
    //MARK: - Action Method
    
    @objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print(#function)
        if gestureRecognizer.state == .recognized {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleDismiss(_ sender: UIPanGestureRecognizer) {
            
            viewTranslation = sender.translation(in: view)
            viewVelocity = sender.velocity(in: view)
            
            switch sender.state {
            case .changed:
                // 상하로 스와이프 할 때 위로 스와이프가 안되게 해주기 위해서 조건 설정
                if viewVelocity.y > 0 {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    })
                }
            case .ended:
                // 해당 뷰의 y값이 400보다 작으면(작게 이동 시) 뷰의 위치를 다시 원상복구하겠다. = 즉, 다시 y=0인 지점으로 리셋
                if viewTranslation.y < 50 {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.view.transform = .identity
                    })
                    // 뷰의 값이 400 이상이면 해당 화면 dismiss
                } else {
                    dismiss(animated: true, completion: nil)
                }
                
            default:
                break
            }
        }
        
        @IBAction func closeButton(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
    
}

extension BaseViewController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("Child ViewControllers", navigationController.viewControllers.count)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1
        
    }

        
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController else { return false }
        return navigationController.viewControllers.count > 1
    }

    
}
