////
////  MyCoordinator.swift
////  ZOOC
////
////  Created by 류희재 on 2023/08/06.
////
//
//import UIKit
//
//protocol Coordinator {
//    func start()
//}
//
//class MyCoordinator: Coordinator {
//    let navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let viewModel = MyViewModel(myNetworkManager: MyAPI(), onboardingNetworkManager: OnboardingAPI()) // ViewModel 생성
//        let viewController = MyViewController(viewModel: viewModel, coordinator: self)
//
//        navigationController.pushViewController(viewController, animated: false) // 화면 전환
//    }
//
//    func pushToEditProfileView(data: UserResult?) {
//        let editProfileViewController = MyEditProfileViewController()
//        editProfileViewController.hidesBottomBarWhenPushed = true
//        editProfileViewController.dataBind(data: data)
//
//        self.navigationController.pushViewController(editProfileViewController, animated: true)
//    }
//
//    func pushToAppInformationView() {
//        let appInformationViewController = MyAppInformationViewController()
//        appInformationViewController.hidesBottomBarWhenPushed = true
//        self.navigationController.pushViewController(appInformationViewController, animated: true)
//    }
//
//    func pushToNoticeSettingView() {
//        let noticeSettingViewController = MyNoticeSettingViewController()
//        noticeSettingViewController.hidesBottomBarWhenPushed = true
//        self.navigationController.pushViewController(noticeSettingViewController, animated: true)
//    }
//
//    func pushToRegisterPetView() {
//        let registerPetViewController = MyRegisterPetViewController(myPetRegisterViewModel: MyPetRegisterViewModel())
//        registerPetViewController.hidesBottomBarWhenPushed = true
//        self.navigationController.pushViewController(registerPetViewController, animated: true)
//    }
//}
