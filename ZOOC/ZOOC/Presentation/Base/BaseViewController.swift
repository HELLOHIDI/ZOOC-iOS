//
//  BaseViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import Photos
import UIKit

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
    public var isPermission: Bool?
    
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
    
    func checkAlbumPermission() {
        print(#function)
        PHPhotoLibrary.requestAuthorization( { status in
            switch status{
            case .authorized:
                self.isPermission = true
            case .denied, .restricted, .notDetermined:
                self.isPermission = false
            default:
                break
            }
        })
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
    
    func validateResult(_ result: NetworkResult<Any>) -> Any?{
        switch result{
        case .success(let data):
            print("성공했습니다.")
            print(data)
            return data
        case .requestErr(let message):
            presentBottomAlert(message)
        case .pathErr:
            presentBottomAlert("path 혹은 method 오류입니다.")
        case .serverErr:
            presentBottomAlert("서버 내 오류입니다.")
        case .networkFail:
            presentBottomAlert("네트워크가 불안정합니다.")
        case .decodedErr:
            presentBottomAlert("디코딩 오류가 발생했습니다.")
        case .authorizationFail(_):
            presentBottomAlert("인증 오류가 발생했습니다. 다시 로그인해주세요")
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
    
}

extension BaseViewController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//
//        print(#function)
//        // 1. 현재 뷰컨트롤러에서 Swipe 제스처 인식기를 생성합니다.
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
//        swipeGesture.direction = .right
//        view.addGestureRecognizer(swipeGesture)
//
//        // 2. 이전 뷰컨트롤러에서 Swipe 제스처 인식기를 제거합니다.
//        if let previousViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) {
//            for recognizer in previousViewController.view.gestureRecognizers ?? [] {
//                previousViewController.view.removeGestureRecognizer(recognizer)
//            }
//        }
//    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("Child ViewControllers", navigationController.viewControllers.count)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1
        
    }

        
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController else { return false }
        return navigationController.viewControllers.count > 1
    }

    
}
