////
////  MyViewController.swift
////  ZOOC
////
////  Created by 장석우 on 2022/12/25.
////
//
//import UIKit
//
//import SnapKit
//import Then
//import Moya
//
//import MessageUI
//
final class MyViewController: BaseViewController {
//
//    //MARK: - Properties
//
//    private let viewModel: MyViewModel
//
//    init(viewModel: MyViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    //MARK: - UI Components
//
//    private lazy var rootView = MyView()
//
//    //MARK: - Life Cycle
//
//    override func loadView() {
//        self.view = rootView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        register()
//        bindUI()
//        bindViewModel()
//        setNotificationCenter()
//    }
//
//    //MARK: - Custom Method
//
//    private func register() {
//        rootView.myCollectionView.delegate = self
//        rootView.myCollectionView.dataSource = self
//    }
//
//    private func bindUI() {
//
//    }
//    private func bindViewModel() {
//
//        let input = MyViewModel.Input(
//        viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
//        logoutButtonDidTapEvent: self.rootView.myCollectionView.rx.itemSelected.asObservable(),
//           deleteAccountButtonDidTapEvent: <#T##Observable<Void>#>,
//           inviteCodeButtonDidTapEvent: <#T##Observable<Void>#>
//        )
//
//        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
//
//        output.ableToPhotoUpload
//            .subscribe(with: self, onNext: { owner, canUpload in
//                guard let canUpload = canUpload else { return }
//                if canUpload { owner.pushToGenAISelectImageVC()}
//                else { owner.presentDenineGenerateAIViewController() }
//            }).disposed(by: disposeBag)
//    }
//
//
//
//
//
//
//
//        viewModel.myProfileData.observe(on: self) { [weak self] _ in
//            self?.rootView.myCollectionView.reloadData()
//        }
//
//        viewModel.myFamilyMemberData.observe(on: self) { [weak self] _ in
//            self?.rootView.myCollectionView.reloadData()
//        }
//
//        viewModel.myPetMemberData.observe(on: self) { [weak self] _ in
//            self?.rootView.myCollectionView.reloadData()
//        }
//
//        viewModel.inviteCode.observe(on: self) { [weak self] inviteCode in
//            guard let code = inviteCode else { return }
//            self?.shareInviteCode(code: code)
//        }
//
//        viewModel.logoutOutput.observe(on: self) { [weak self] isLogout in
//            guard let isLogout = isLogout  else { return }
//            if isLogout {
//                let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
//                onboardingNVC.setNavigationBarHidden(true, animated: true)
//                UIApplication.shared.changeRootViewController(onboardingNVC)}
//            else {
//                self?.showToast("로그아웃에 실패했습니다.", type: .bad)
//
//            }
//        }
//
//        viewModel.deleteAccoutOutput.observe(on: self) { [weak self] isDeleted in
//            guard let isDeleted = isDeleted else { return }
//            if isDeleted {
//                let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
//                onboardingNVC.setNavigationBarHidden(true, animated: true)
//                UIApplication.shared.changeRootViewController(onboardingNVC)
//            } else { self?.showToast("회원 탈퇴에 실패했습니다.", type: .bad)}
//
//        }
//    }
//
//    private func setNotificationCenter() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(updateUI),
//            name: .myPageUpdate,
//            object: nil
//        )
//    }
//
//    //MARK: - Action Method
//
//    @objc private func updateUI() {
//        viewModel.viewWillAppearEvent() // 여긴 다시 봐야될듯
//    }
//
//    @objc private func editProfileButtonDidTap() { // -> 개방 폐쇄의 원리
//        pushToEditProfileView()
//    }
//
//    @objc private func appInformationButtonDidTap() {
//        pushToAppInformationView()
//    }
//
//    @objc func inviteButtonDidTap() {
//        viewModel.inviteCodeButtonDidTapEvent()
//    }
//}
//
////MARK: - UICollectionView Delegate
//
//extension MyViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            pushToEditProfileView()
//        case 2:
//            pushToRegisterPetView()
//        default: return
//        }
//    }
//}
//
////MARK: - UICollectionViewDelegateFlowLayout
//
//extension MyViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch indexPath.section {
//        case 0:
//            return CGSize(width: 315, height: 140)
//        case 1:
//            return CGSize(width: 315, height: 155)
//        case 2:
//            return CGSize(width: 315, height: 127)
//        case 3:
//            return CGSize(width: 315, height: 284)
//        case 4:
//            return CGSize(width: 315, height: 17)
//        default:
//            return CGSize(width: 0, height: 0)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        switch section {
//        case 0:
//            return UIEdgeInsets(top: 38, left: 30, bottom: 0, right: 30)
//        case 1:
//            return UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
//        case 2:
//            return UIEdgeInsets(top: 0, left: 30, bottom: 22, right: 30)
//        case 3:
//            return UIEdgeInsets(top: 0, left: 30, bottom: 40, right: 30)
//        case 4:
//            return UIEdgeInsets(top: 0, left: 0, bottom: 103, right: 0)
//        default:
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
//}
//
////MARK: - UICollectionViewDataSource
//
//extension MyViewController: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileSectionCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? MyProfileSectionCollectionViewCell else { return UICollectionViewCell() }
//            cell.dataBind(data: viewModel.myProfileData.value)
//            cell.editProfileButton.addTarget(self, action: #selector(editProfileButtonDidTap), for: .touchUpInside)
//            return cell
//
//        case 1:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFamilySectionCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? MyFamilySectionCollectionViewCell else { return UICollectionViewCell() }
//            cell.dataBind(myFamilyData: viewModel.myFamilyMemberData.value, myProfileData: viewModel.myProfileData.value)
//            cell.inviteButton.addTarget(self, action: #selector(inviteButtonDidTap), for: .touchUpInside)
//            return cell
//
//        case 2:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPetSectionCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? MyPetSectionCollectionViewCell else { return UICollectionViewCell() }
//            cell.dataBind(myPetMemberData: viewModel.myPetMemberData.value)
//            cell.delegate = self
//            return cell
//
//        case 3:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MySettingSectionCollectionViewCell.cellIdentifier, for: indexPath) as? MySettingSectionCollectionViewCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//
//        case 4:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDeleteAccountSectionCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? MyDeleteAccountSectionCollectionViewCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//
//        default:
//            return UICollectionViewCell()
//        }
//    }
//}
//
////MARK: - SettingMenuTableViewCellDelegate
//
//extension MyViewController: SettingMenuTableViewCellDelegate {
//    func selectedSettingMenuTableViewCell(indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0: // 알림설정
//            pushToNoticeSettingView()
//        case 1: // 공지사항
//            let url = ExternalURL.zoocDefaultURL
//            presentSafariViewController(url)
//        case 2: // 문의하기
//            sendMail(subject: "[ZOOC] 문의하기", body: TextLiteral.mailInquiryBody)
//        case 3: // 앱 정보
//            pushToAppInformationView()
//        case 4: // 로그아웃
//            viewModel.logoutButtonDidTapEvent()
//        default:
//            break
//        }
//    }
//}
//
////MARK: - MyRegisterPetButtonTappedDelegate
//
//extension MyViewController: MyRegisterPetButtonTappedDelegate {
//    func petCellTapped(pet: PetResult) {
//        presentToEditPetProfileView(pet: pet)
//    }
//
//    func myRegisterPetButtonTapped(isSelected: Bool) {
//        pushToRegisterPetView()
//    }
//}
//
//extension MyViewController: MyDeleteAccountSectionCollectionViewCellDelegate {
//    func deleteAccountButtonDidTapped() {
//        let zoocAlertVC = ZoocAlertViewController(.deleteAccount)
//        zoocAlertVC.delegate = self
//        present(zoocAlertVC, animated: false)
//    }
//}
//
//extension MyViewController {
//    func pushToEditProfileView() {
//        let hasPhoto = viewModel.myProfileData.value?.photo == nil ? false : true
//        let imageView = UIImageView()
//        imageView.kfSetImage(url: viewModel.myProfileData.value?.photo)
//        let image = imageView.image
//        let photo = hasPhoto ? image : nil
//        let editProfileViewController = MyEditProfileViewController(
//            viewModel: MyEditProfileViewModel(
//                editProfileData: EditProfileRequest(
//                    hasPhoto: hasPhoto,
//                    nickName: viewModel.myProfileData.value?.nickName ?? "",
//                    profileImage: photo
//                ),
//                repository: MyEditProfileRepositoryImpl()
//            )
//        )
//        editProfileViewController.hidesBottomBarWhenPushed = true
//
//        self.navigationController?.pushViewController(editProfileViewController, animated: true)
//    }
//
//    func pushToAppInformationView() {
//        let appInformationViewController = MyAppInformationViewController()
//        appInformationViewController.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(appInformationViewController, animated: true)
//    }
//
//    func pushToNoticeSettingView() {
//        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//    }
//
//    func pushToRegisterPetView() {
//        let registerPetViewController = MyRegisterPetViewController(myPetRegisterViewModel: MyPetRegisterViewModel())
//        registerPetViewController.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(registerPetViewController, animated: true)
//    }
//
//    private func presentToEditPetProfileView(pet: PetResult) {
//        let hasPhoto = pet.photo == nil ? false : true
//        let imageView = UIImageView()
//        imageView.kfSetImage(url: pet.photo)
//        let image = imageView.image
//        let photo = hasPhoto ? image : nil
//        let editPetProfileView = MyEditPetProfileViewController(
//            viewModel: DefaultMyEditPetProfileViewModel(
//                id: pet.id,
//                editPetProfileRequest: EditPetProfileRequest(
//                    photo: hasPhoto,
//                    nickName: pet.name,
//                    file: photo
//                ),
//                repository: MyEditPetProfileRepositoryImpl()
//            )
//        )
//        editPetProfileView.modalPresentationStyle = .fullScreen
//        self.present(editPetProfileView, animated: true)
//    }
//
//    private func shareInviteCode(code: String) {
//        var objectToShare = [String]()
//
//        objectToShare.append(code)
//
//        let activityViewController = UIActivityViewController(activityItems : objectToShare, applicationActivities: nil)
//
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)
//
//        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
//            let message = success ? "초대 코드 복사에 성공했습니다"  : "초대 코드 복사가 되지 않았어요"
//            let type: Toast.ToastType = success ? .good : .bad
//            self.showToast(message, type: type)
//        }
//    }
//}
//
//
//extension MyViewController: ZoocAlertViewControllerDelegate {
//    func exitButtonDidTap() {
//        viewModel.deleteAccountButtonDidTapEvent()
//    }
//}
//
//
//extension MyViewController: MFMailComposeViewControllerDelegate {
//    private func sendMail(subject: String, body: String) {
//        if MFMailComposeViewController.canSendMail() {
//            let composeViewController = MFMailComposeViewController()
//            composeViewController.mailComposeDelegate = self
//
//
//            composeViewController.setToRecipients(["thekimhyo@gmail.com"])
//            composeViewController.setSubject(subject)
//            composeViewController.setMessageBody(body, isHTML: false)
//
//            self.present(composeViewController, animated: true, completion: nil)
//        } else {
//            print("메일 보내기 실패")
//            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패",
//                                                       message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
//                                                       preferredStyle: .alert)
//            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
//                // 앱스토어로 이동하기(Mail)
//                let url = "https://apps.apple.com/kr/app/mail/id1108187098"
//                self.presentSafariViewController(url)
//            }
//            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
//
//            sendMailErrorAlert.addAction(goAppStoreAction)
//            sendMailErrorAlert.addAction(cancleAction)
//            self.present(sendMailErrorAlert, animated: true, completion: nil)
//        }
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        switch result {
//        case .cancelled:
//            showToast("메일 보내기가 취소되었습니다.", type: .normal)
//        case .sent:
//            showToast("메일이 성공적으로 보내졌습니다.", type: .good)
//        case .saved:
//            showToast("메일이 저장되었습니다.", type: .normal)
//        case .failed:
//            showToast("메일 보내기에 오류가 발생했습니다.", type: .normal)
//        default:
//            break
//        }
//        controller.dismiss(animated: true, completion: nil)
//    }
}
