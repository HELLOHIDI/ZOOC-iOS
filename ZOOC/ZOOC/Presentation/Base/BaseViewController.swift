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
        dismissKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        case .decodedErr:            presentBottomAlert("디코딩 오류가 발생했습니다.")
        }
        return nil
    }
    
    //MARK: - Keyboard 관련 처리
    
    
    //MARK: - Action Method
    
}
