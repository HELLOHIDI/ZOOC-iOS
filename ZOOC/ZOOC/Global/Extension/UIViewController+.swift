//
//  UIViewController+.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

extension UIViewController{
    
//    func presentBottomAlert(_ message: String) {
//      
//        let alertSuperview: UIView = {
//            let view = UIView()
//            view.backgroundColor = .darkGray.withAlphaComponent(0.85)
//            view.layer.cornerRadius = 10
//            view.isHidden = true
//            return view
//        }()
//    
//        
//        let alertLabel: UILabel = {
//            let label = UILabel()
//            label.font = .systemFont(ofSize: 15)
//            label.textColor = .white
//            label.text = message
//            return label
//        }()
//        
//        view.addSubview(alertSuperview)
//        alertSuperview.addSubview(alertLabel)
//        alertSuperview.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(40)
//        }
//        
//        alertLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
//        
//        
//        alertLabel.text = message
//        alertSuperview.alpha = 1.0
//        alertSuperview.isHidden = false
//        
//        UIView.animate(
//            withDuration: 2.0,
//            delay: 1.0,
//            options: .curveEaseIn,
//            animations: { alertSuperview.alpha = 0 },
//            completion: { _ in
//                alertSuperview.removeFromSuperview()
//            }
//        )
//    }
    
    // MARK: 2023.09.07 생성. 커스텀 가능한 bottomAlert를 만들기 위해 추가 구현.
    // TODO: presentBottom -> ShowToast로 모두 변경하기
    
    func showToast(_ message: String,
                   type: Toast.ToastType,
                   bottomInset: CGFloat = 40) {
        Toast().show(message: message,
                     type: type,
                     view: self.view,
                     bottomInset: bottomInset)
    }
    
    
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification ,
                                               object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func addKeyboardNotifications(view: UIView){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification ,
                                               object: view)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: view)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification ,
                                                  object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    func dismissKeyboardWhenTappedAround(cancelsTouchesInView: Bool = false) {
        print(#function)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - Action Method
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        // 키보드의 높이만큼 화면을 올려준다.
        print("키보드 올라감")
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        if let view = notification.object as? UIView{
            view.frame.origin.y -= keyboardHeight
        }
        guard view.frame.origin.y == 0 else { return }
        self.view.frame.origin.y -= keyboardHeight
        Device.keyBoardHeight = keyboardHeight
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillHide(_ notification: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        print("키보드 내려감")
        
        if let view = notification.object as? UIView{
            view.frame.origin.y += Device.keyBoardHeight

        } else {
            guard view.frame.origin.y < 0 else { return }
            self.view.frame.origin.y += Device.keyBoardHeight
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          dismissKeyboard()
    }
}
