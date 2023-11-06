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
    
    private var petData: [PetResult] = []
    
    let homeViewController = ShopViewController(viewModel: ShopViewModel(1))
    let explorePetViewController = ExploreViewController()
    let myViewController = MyViewController(viewModel:
                                                MyViewModel(myUseCase:
                                                                DefaultMyUseCase(repository:
                                                                                    DefaultMyRepository())))
    
    lazy var homeNavigationContrller = UINavigationController(rootViewController: homeViewController)
    lazy var exploreNavigationController = UINavigationController(rootViewController: explorePetViewController)
    lazy var myNavigationController = UINavigationController(rootViewController: myViewController)
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setTabBar()
        setTabBarItems()
        setViewControllers()
        //requestTotalPetAPI()
        selectedIndex = 0
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 100
        tabBar.frame.origin.y = view.frame.height - 100
    }
    
    //MARK: - Custom Method
    
    private func setTabBar(){
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        tabBar.backgroundColor = .zw_tabbar_backgound
        tabBar.tintColor = .zw_black
        tabBar.itemPositioning = .centered
        
        tabBar.makeShadow(color: .black.withAlphaComponent(0.05),
                          offset: .zero,
                          radius: 30,
                          opacity: 1)
    }
    
    private func setTabBarItems() {
        homeNavigationContrller.tabBarItem = UITabBarItem(title: nil,
                                                          image: .zwImage(.ic_home_inactive),
                                                          selectedImage: .zwImage(.ic_home_active))
        
        exploreNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                              image: .zwImage(.ic_explore_inactive),
                                                              selectedImage: .zwImage(.ic_explore_active))
        
        myNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                         image: .zwImage(.ic_my_inactive),
                                                         selectedImage: .zwImage(.ic_my_inactive))
        
        homeNavigationContrller.tabBarItem.imageInsets = .init(top: 5, left: 15, bottom: 0, right: -15)
        exploreNavigationController.tabBarItem.imageInsets = .init(top: 5, left: 0, bottom: 0, right: 0)
        myNavigationController.tabBarItem.imageInsets = .init(top: 5, left: -15, bottom: 0, right: 15)
    }
    
    private func setViewControllers(){
        viewControllers = [homeNavigationContrller,
                           exploreNavigationController,
                           myNavigationController]
    }
    
    
    private func requestTotalPetAPI() {
        HomeAPI.shared.getTotalPet(familyID: UserDefaultsManager.familyID) { result in
            switch result {
            case .success(let data):
                guard let data = data as? [PetResult] else { return }
                self.petData = data
            default:
                break
            }
        }
    }
}


extension ZoocTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        let impactService = Haptic.impact(.light)
        impactService.run()
    }
}



//extension ZoocTabBarController: ZoocAlertViewControllerDelegate {
//    func keepButtonDidTap() {
//        let myRegisterPetVC = MyRegisterPetViewController(
//            viewModel: MyRegisterPetViewModel(
//                myRegisterPetUseCase: DefaultMyRegisterPetUseCase(
//                    repository: DefaultMyRepository()
//                )
//            )
//        )
//        let myRegisterPetNVC = UINavigationController(rootViewController: myRegisterPetVC)
//        myRegisterPetNVC.modalPresentationStyle = .fullScreen
//        myRegisterPetNVC.setNavigationBarHidden(true, animated: true)
//        self.present(myRegisterPetNVC, animated: true)
//    }
//
//    func exitButtonDidTap() {
//        self.dismiss(animated: true)
//    }
//}
