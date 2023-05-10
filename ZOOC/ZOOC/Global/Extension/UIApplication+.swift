//
//  UIApplication+.swift
//  ZOOC
//
//  Created by 장석우 on 2023/04/26.
//

import UIKit

extension UIApplication {
    
    func changeRootViewController(_ viewController: UIViewController) {
        guard let firstWindow = firstWindow else {
            print("윈도우 생성 전입니다.")
            return
        }
        
        firstWindow.rootViewController = viewController
        firstWindow.makeKeyAndVisible()
        UIView.transition(with: firstWindow,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
    
    var rootViewController: UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        
        let firstWindow = windowScenes?.windows.filter { $0.isKeyWindow }.first
        return firstWindow?.rootViewController
    }
    
    var firstWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        
        return windowScenes?.windows.filter { $0.isKeyWindow }.first
    }
}
