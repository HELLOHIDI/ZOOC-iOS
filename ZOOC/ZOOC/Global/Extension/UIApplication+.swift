//
//  UIApplication+.swift
//  ZOOC
//
//  Created by 장석우 on 2023/04/26.
//

import UIKit

extension UIApplication {
    
    func changeRootViewController(_ viewController: UIViewController) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        
        let firstWindow = windowScenes?.windows.filter { $0.isKeyWindow }.first
        firstWindow?.rootViewController = viewController
        firstWindow?.makeKeyAndVisible()
        UIView.transition(with: firstWindow!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil)
        
    }
}
