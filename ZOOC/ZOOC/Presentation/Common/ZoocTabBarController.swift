//
//  ZoocTabBarController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import UIKit

import SnapKit
import Then

class ZoocTabBarController: UITabBarController {
    
    
    //MARK: - Properties
    
    let homeViewController = HomeViewController()
    let myViewController = MyViewController(
        viewModel: MyViewModel(
            myUseCase: DefaultMyUseCase(
                repository: MyRepositoryImpl()
            )
        )
    )
    lazy var homeNavigationContrller = UINavigationController(rootViewController: homeViewController)
    lazy var myNavigationController = UINavigationController(rootViewController: myViewController)
    
    
    
    //MARK: - UI Components
    
    private lazy var plusButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(Image.plusTabCircle, for: .normal)
        $0.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        setLayout()
        setNavigationController()
        setViewController()
        setCornerRadius()
        selectedIndex = 0
        
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //
    //        tabBar.frame.size.height = 96
    //        tabBar.frame.origin.y = view.frame.height - 96
    //
    //    }
    
    //MARK: - Custom Method
    
    private func setTabBar(){
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        //tabBar.isTranslucent = false
        tabBar.backgroundColor = .zoocWhite1
        tabBar.tintColor = .black
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 130
    }
    
    private func setLayout(){
        tabBar.addSubview(plusButton)
        
        plusButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(tabBar.snp.top).offset(17)
            $0.width.height.equalTo(90)
        }
    }
    
    private func setCornerRadius(){
        tabBar.layer.cornerRadius = 24
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
    }
    
    private func setNavigationController() {
        homeNavigationContrller.setNavigationBarHidden(true, animated: true)
        myNavigationController.setNavigationBarHidden(true, animated: true)
    }
    
    private func setViewController(){
        
        homeNavigationContrller.tabBarItem = UITabBarItem(title: "",
                                                          image: Image.home,
                                                          selectedImage: Image.home)
        
        myNavigationController.tabBarItem = UITabBarItem(title: "",
                                                         image: Image.person,
                                                         selectedImage: Image.person)
        
        viewControllers = [homeNavigationContrller,myNavigationController]
    }
    
    //MARK: - Action Method
    
    @objc func plusButtonDidTap(){
        requestTotalPetAPI()
        
    }
    
    
    private func requestTotalPetAPI() {
        HomeAPI.shared.getTotalPet(familyID: UserDefaultsManager.familyID) { result in
            switch result {
            case .success(let data):
                guard let result = data as? [PetResult] else { return }
                if result.isEmpty {
                    self.presentZoocAlertVC()
                } else {
                    let recordVC = RecordViewController(
                        viewModel: RecordViewModel(
                            recordUseCase: DefaultRecordUseCase()
                        )
                    )
                    let recordNVC = UINavigationController(rootViewController: recordVC)
                    recordNVC.modalPresentationStyle = .fullScreen
                    recordNVC.setNavigationBarHidden(true, animated: true)
                    self.present(recordNVC, animated: true)
                }
            default:
                break
            }
        }
    }
    
    private func presentZoocAlertVC() {
        let alertVC = ZoocAlertViewController(.noPet)
        alertVC.delegate = self
        present(alertVC, animated: false)
    }
}

extension ZoocTabBarController: ZoocAlertViewControllerDelegate {
    func keepButtonDidTap() {
        let myRegisterPetVC = MyRegisterPetViewController(
            viewModel: MyRegisterPetViewModel(
                myRegisterPetUseCase: DefaultMyRegisterPetUseCase(
                    repository: MyRepositoryImpl()
                )
            )
        )
        let myRegisterPetNVC = UINavigationController(rootViewController: myRegisterPetVC)
        myRegisterPetNVC.modalPresentationStyle = .fullScreen
        myRegisterPetNVC.setNavigationBarHidden(true, animated: true)
        self.present(myRegisterPetNVC, animated: true)
    }
    
    func exitButtonDidTap() {
        self.dismiss(animated: true)
    }
}



