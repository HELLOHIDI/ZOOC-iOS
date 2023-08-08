//
//  MyViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import UIKit

import SnapKit
import Then
import Moya

import MessageUI

final class MyViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyViewModel
    
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
        
        register()
        setNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestMyPageAPI()
    }
    
    //MARK: - Custom Method
    
    private func register() {
        rootView.myCollectionView.delegate = self
        rootView.myCollectionView.dataSource = self
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUI),
            name: .myPageUpdate,
            object: nil
        )
    }
    
    @objc private func updateUI() {
        requestMyPageAPI()
    }
    
    func requestMyPageAPI(){
        viewModel.requestMyPageAPI() { success, error in
            if success { self.rootView.myCollectionView.reloadData() }
            else { self.presentBottomAlert(error!) }
        }
    }
    
    private func requestLogoutAPI() {
        viewModel.requestLogoutAPI() {
            let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
            onboardingNVC.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.changeRootViewController(onboardingNVC)
        }
    }
    
    //MARK: - Action Method
    
    @objc private func editProfileButtonDidTap() { // -> 개방 폐쇄의 원리
        pushToEditProfileView()
    }
    
    @objc private func appInformationButtonDidTap() {
        pushToAppInformationView()
    }
    
    @objc func inviteButtonDidTap() {
        viewModel.getInviteCode() {
            self.shareInviteCode(code: self.viewModel.inviteCode!)
        }
    }
}

//MARK: - UICollectionView Delegate

extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            pushToEditProfileView()
        case 2:
            pushToRegisterPetView()
        default: return
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 315, height: 140)
        case 1:
            return CGSize(width: 315, height: 155)
        case 2:
            return CGSize(width: 315, height: 127)
        case 3:
            return CGSize(width: 315, height: 346)
        case 4:
            return CGSize(width: 315, height: 17)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 38, left: 30, bottom: 0, right: 30)
        case 1:
            return UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        case 2:
            return UIEdgeInsets(top: 0, left: 30, bottom: 22, right: 30)
        case 3:
            return UIEdgeInsets(top: 0, left: 30, bottom: 40, right: 30)
        case 4:
            return UIEdgeInsets(top: 0, left: 0, bottom: 103, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension MyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileSectionCollectionViewCell.cellIdentifier, for: indexPath)
                    as? MyProfileSectionCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(data: viewModel.myProfileData)
            cell.editProfileButton.addTarget(self, action: #selector(editProfileButtonDidTap), for: .touchUpInside)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFamilySectionCollectionViewCell.cellIdentifier, for: indexPath)
                    as? MyFamilySectionCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(myFamilyData: viewModel.myFamilyMemberData, myProfileData: viewModel.myProfileData)
            cell.inviteButton.addTarget(self, action: #selector(inviteButtonDidTap), for: .touchUpInside)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPetSectionCollectionViewCell.cellIdentifier, for: indexPath)
                    as? MyPetSectionCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(myPetMemberData: viewModel.myPetMemberData)
            cell.delegate = self
            return cell
            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MySettingSectionCollectionViewCell.cellIdentifier, for: indexPath) as? MySettingSectionCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
            
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDeleteAccountSectionCollectionViewCell.cellIdentifier, for: indexPath)
                    as? MyDeleteAccountSectionCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
            
        default:
            return UICollectionViewCell()
        }
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
        case 2: // 문의하기
            sendMail(subject: "[ZOOC] 문의하기", body: TextLiteral.mailInquiryBody)
        case 3: // 미션 제안하기
            sendMail(subject: "[ZOOC] 미션 제안하기", body: TextLiteral.mailMissionAdviceBody)
        case 4: // 앱 정보
            pushToAppInformationView()
        case 5: // 로그아웃
            requestLogoutAPI()
        default:
            break
        }
    }
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

extension MyViewController: MyDeleteAccountSectionCollectionViewCellDelegate {
    func deleteAccountButtonDidTapped() {
        let zoocAlertVC = ZoocAlertViewController()
        zoocAlertVC.delegate = self
        zoocAlertVC.alertType = .deleteAccount
        zoocAlertVC.modalPresentationStyle = .overFullScreen
        present(zoocAlertVC, animated: false)
    }
}

extension MyViewController {
    func pushToEditProfileView() {
        let hasPhoto = viewModel.myProfileData?.photo == nil ? false : true
        let imageView = UIImageView()
        imageView.kfSetImage(url: viewModel.myProfileData?.photo)
        let image = imageView.image
        let photo = hasPhoto ? image : nil
        let editProfileViewController = MyEditProfileViewController(
            viewModel: MyEditProfileViewModel(
                name: viewModel.myProfileData?.nickName ?? "",
                photo: photo,
                hasPhoto: hasPhoto)
        )
        editProfileViewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    func pushToAppInformationView() {
        let appInformationViewController = MyAppInformationViewController()
        appInformationViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(appInformationViewController, animated: true)
    }
    
    func pushToNoticeSettingView() {
        let noticeSettingViewController = MyNoticeSettingViewController()
        noticeSettingViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(noticeSettingViewController, animated: true)
    }
    
    func pushToRegisterPetView() {
        let registerPetViewController = MyRegisterPetViewController(myPetRegisterViewModel: MyPetRegisterViewModel())
        registerPetViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(registerPetViewController, animated: true)
    }
    
    private func presentToEditPetProfileView(pet: PetResult) {
        let hasPhoto = pet.photo == nil ? false : true
        let imageView = UIImageView()
        imageView.kfSetImage(url: pet.photo)
        let image = imageView.image
        let photo = hasPhoto ? image : nil
        let editPetProfileView = MyEditPetProfileViewController(
            viewModel: MyEditPetProfileViewModel(
                id: pet.id,
                name: pet.name,
                photo: photo,
                hasPhoto: hasPhoto
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
            let message = success ? "초대 코드 복사에 성공했습니다"  : "초대 코드 복사에 실패했습니다"
            let title = success ? "복사 성공" : "복사 실패"
            self.showAlertCopyCompleted(message: message, title: title)
        }
    }
    
    private func showAlertCopyCompleted(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
}


extension MyViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        viewModel.deleteAccount() {
            let onboardingNVC = UINavigationController(rootViewController: OnboardingLoginViewController())
            onboardingNVC.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.changeRootViewController(onboardingNVC)
            
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
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
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
            presentBottomAlert("메일 보내기가 취소되었습니다.")
        case .sent:
            presentBottomAlert("메일이 성공적으로 보내졌습니다.")
        case .saved:
            presentBottomAlert("메일이 저장되었습니다.")
        case .failed:
            presentBottomAlert("메일 보내기 실패")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
