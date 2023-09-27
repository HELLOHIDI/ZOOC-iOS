//
//  MyViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import MessageUI

final class MyViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyViewModel
    private let disposeBag = DisposeBag()
    
    private let deleteAccountSubject = PublishSubject<Void>()
    
    init(viewModel: MyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    private lazy var rootView = MyView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        bindUI()
        bindViewModel()
        //        setNotificationCenter()
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        rootView.petView.delegate = self
        rootView.settingView.delegate = self
    }
    
    private func bindUI() {
        rootView.profileView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToEditProfileView()
            }).disposed(by: disposeBag)
        
        rootView.profileView.editProfileButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToEditProfileView()
            }).disposed(by: disposeBag)
        
        rootView.deleteAccountView.deleteAccountButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentDeleteAccountZoocAlertView()
            }).disposed(by: disposeBag)
        
    }
    private func bindViewModel() {
        let input = MyViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            logoutButtonDidTapEvent: self.rootView.settingView.settingMenuTableView.rx.itemSelected.asObservable()
                .filter({ $0.item == 4 }),
            deleteAccountButtonDidTapEvent: deleteAccountSubject.asObservable(),
            inviteCodeButtonDidTapEvent: self.rootView.familyView.inviteButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.isloggedOut
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, isLogout in
                guard let isLogout = isLogout else { return }
                if isLogout {
                    let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
                    UIApplication.shared.changeRootViewController(onboardingNVC)
                } else {
                    owner.showToast("로그아웃에 실패했습니다.", type: .bad)
                }
            }).disposed(by: disposeBag)
        
        output.isDeletedAccount
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, isDeleted in
                guard let isDeleted = isDeleted else { return }
                if isDeleted {
                    let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
                    onboardingNVC.setNavigationBarHidden(true, animated: true)
                    UIApplication.shared.changeRootViewController(onboardingNVC)
                } else {
                    owner.showToast("회원 탈퇴에 실패했습니다.", type: .bad)
                }
            }).disposed(by: disposeBag)
        
        output.inviteCode
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, inviteCode in
                guard let code = inviteCode else { return }
                owner.shareInviteCode(code: code)
            }).disposed(by: disposeBag)
        
        output.profileData
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, profileData in
                owner.updateProfileView(profileData)
            }).disposed(by: disposeBag)
        
        output.familyMemberData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, familyData in
                owner.updateFamilyView(familyData)
            }).disposed(by: disposeBag)
        
        output.petMemberData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext:  { owner, petData in
                owner.updatePetView(petData)
            }).disposed(by: disposeBag)
    }
    
    //    private func setNotificationCenter() {
    //        NotificationCenter.default.addObserver(
    //            self,
    //            selector: #selector(updateUI),
    //            name: .myPageUpdate,
    //            object: nil
    //        )
    //    }
}

//MARK: - MyRegisterPetButtonTappedDelegate

extension MyViewController: MyRegisterPetButtonTappedDelegate {
    func petCellTapped(pet: PetResult) {
        presentToEditPetProfileView(pet: pet)
    }
    
    func myRegisterPetButtonTapped(isSelected: Bool) {
        pushToRegisterPetView()
    }
}

//MARK: - SettingMenuTableViewCellDelegate

extension MyViewController: SettingMenuTableViewCellDelegate {
    func selectedSettingMenuTableViewCell(indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 알림설정
            pushToNoticeSettingView()
        case 1: // 공지사항
            let url = ExternalURL.zoocDefaultURL
            presentSafariViewController(url)
            break
        case 2: // 문의하기
            sendMail(subject: "[ZOOC] 문의하기", body: TextLiteral.mailInquiryBody)
            break
        case 3: // 앱 정보
            pushToAppInformationView()
        case 4: // 로그아웃
            return
        default:
            break
        }
    }
}

extension MyViewController {
    private func pushToEditProfileView() {
        let hasPhoto = viewModel.getProfileData()?.photo != nil
        let imageView = UIImageView()
        imageView.kfSetImage(url: viewModel.getProfileData()?.photo)
        let image = imageView.image
        let photo = hasPhoto ? image : nil
        let editProfileVC = MyEditProfileViewController(
            viewModel: MyEditProfileViewModel(
                myEditProfileUseCase: DefaultMyEditProfileUseCase(
                    profileData: EditProfileRequest(
                        hasPhoto: hasPhoto,
                        nickName: viewModel.getProfileData()?.nickName ?? "",
                        profileImage: photo
                    ),
                    repository: MyRepositoryImpl()
                )
            )
        )
        
        editProfileVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func pushToAppInformationView() {
        let appInformationVC = MyAppInformationViewController()
        appInformationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(appInformationVC, animated: true)
    }
    
    private func pushToNoticeSettingView() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    private func pushToRegisterPetView() {
        let registerPetVC = MyRegisterPetViewController(myPetRegisterViewModel: MyPetRegisterViewModel())
        registerPetVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(registerPetVC, animated: true)
    }
    
    private func presentDeleteAccountZoocAlertView() {
        print(#function)
        let zoocAlertVC = ZoocAlertViewController(.deleteAccount)
        zoocAlertVC.delegate = self
        present(zoocAlertVC, animated: false)
    }
    
    private func presentToEditPetProfileView(pet: PetResult) {
        let hasPhoto = pet.photo == nil ? false : true
        let imageView = UIImageView()
        imageView.kfSetImage(url: pet.photo)
        let image = imageView.image
        let photo = hasPhoto ? image : nil
        let editPetProfileView = MyEditPetProfileViewController(
            viewModel: MyEditPetProfileViewModel(
                myEditPetProfileUseCase: DefaultMyEditPetProfileUseCase(
                    petProfileData: EditPetProfileRequest(
                        photo: hasPhoto,
                        nickName: pet.name,
                        file: photo
                    ),
                    repository: MyRepositoryImpl())
            )
        )
        editPetProfileView.modalPresentationStyle = .fullScreen
        self.present(editPetProfileView, animated: true)
    }
    
    private func shareInviteCode(code: String) {
        var objectToShare = [String]()
        
        objectToShare.append(code)
        
        let activityViewController = UIActivityViewController(activityItems : objectToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            let message = success ? "초대 코드 복사에 성공했습니다"  : "초대 코드 복사가 되지 않았어요"
            let type: Toast.ToastType = success ? .good : .bad
            self.showToast(message, type: type)
        }
    }
}

extension MyViewController: MFMailComposeViewControllerDelegate {
    private func sendMail(subject: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            
            composeViewController.setToRecipients(["thekimhyo@gmail.com"])
            composeViewController.setSubject(subject)
            composeViewController.setMessageBody(body, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패",
                                                       message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
                                                       preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                let url = "https://apps.apple.com/kr/app/mail/id1108187098"
                self.presentSafariViewController(url)
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            showToast("메일 보내기가 취소되었습니다.", type: .normal)
        case .sent:
            showToast("메일이 성공적으로 보내졌습니다.", type: .good)
        case .saved:
            showToast("메일이 저장되었습니다.", type: .normal)
        case .failed:
            showToast("메일 보내기에 오류가 발생했습니다.", type: .normal)
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension MyViewController {
    func updateProfileView(_ data: UserResult?) {
        rootView.profileView.profileNameLabel.text = data?.nickName
        if let photo = data?.photo {
            rootView.profileView.profileImageView.kfSetImage(url: photo)
        } else {
            rootView.profileView.profileImageView.image = Image.defaultProfile
        }
    }
    
    func updateFamilyView(_ familyData: [UserResult] ) {
        rootView.familyView.updateUI(familyData)
    }
    
    func updatePetView(_ petData: [PetResult]) {
        rootView.petView.updateUI(petData)
    }
}

extension MyViewController: ZoocAlertViewControllerDelegate {
    func keepButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    func exitButtonDidTap() {
        deleteAccountSubject.onNext(())
    }
}
