//
//  BaseViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import UIKit

import SnapKit
import Then

class BaseViewController : UIViewController{
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        dismissKeyboardWhenTappedAround()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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
