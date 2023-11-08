//
//  EditProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/04.
//

import UIKit
import RxSwift
import RxCocoa

final class MyEditProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyEditProfileViewModel
    private let disposeBag = DisposeBag()
    
    private let selectProfileImageSubject = PublishSubject<UIImage>()
    
    init(viewModel: MyEditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIComponents
    
    private lazy var rootView = MyEditProfileView()
    
    //    private var galleryAlertController: GalleryAlertController {
    //        let galleryAlertController = GalleryAlertController()
    //        galleryAlertController.delegate = self
    //        return galleryAlertController
    //    }
    //
    //    private lazy var imagePickerController: UIImagePickerController = {
    //        let imagePickerController = UIImagePickerController()
    //        imagePickerController.sourceType = .photoLibrary
    //        imagePickerController.allowsEditing = true
    //        imagePickerController.delegate = self
    //        return imagePickerController
    //    }()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        bindUI()
        //        bindViewModel()
    }
    
    //MARK: - Custom Method
    //
    //    private func bindUI() {
    //        self.rx.viewWillAppear
    //            .subscribe(with: self, onNext: { owner, _ in
    //                owner.navigationController?.isNavigationBarHidden = true
    //            }).disposed(by: disposeBag)
    //        rootView.backButton.rx.tap
    //            .subscribe(with: self, onNext: { owner, _ in
    //                let zoocAlertVC = ZoocAlertViewController(.leavePage)
    //                zoocAlertVC.delegate = owner
    //                owner.present(zoocAlertVC, animated: false)
    //            }).disposed(by: disposeBag)
    //
    //        rootView.profileImageButton.rx.tap
    //            .subscribe(with: self, onNext: { owner, _ in
    //                owner.present(owner.galleryAlertController,animated: true)
    //            }).disposed(by: disposeBag)
    //    }
    //
    //    private func bindViewModel() {
    //        let input = MyEditProfileViewModel.Input(
    //            nameTextFieldDidChangeEvent: rootView.nameTextField.rx.controlEvent(.editingChanged).map { [weak self] in
    //                self?.rootView.nameTextField.text ?? "" }
    //                .asObservable(),
    //            editButtonTapEvent: self.rootView.completeButton.rx.tap.asObservable(),
    //            selectImageEvent: selectProfileImageSubject.asObservable()
    //        )
    //
    //        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    //
    //        output.ableToEditProfile
    //            .asDriver()
    //            .drive(with: self, onNext: { owner, canEdit in
    //                owner.rootView.completeButton.isEnabled = canEdit
    //            }).disposed(by: disposeBag)
    //
    //        output.isEdited
    //            .asDriver(onErrorJustReturn: Bool())
    //            .drive(with: self, onNext: { owner, isEdited in
    //                if isEdited { if let presentingViewController = owner.presentingViewController {
    //                    presentingViewController.dismiss(animated: true)
    //                } else if let navigationController = owner.navigationController {
    //                    navigationController.popViewController(animated: true) }
    //                }
    //                else { owner.showToast("다시 시도해주세요", type: .bad)}
    //            }).disposed(by: disposeBag)
    //
    //        output.profileData
    //            .asDriver(onErrorJustReturn: nil)
    //            .drive(with: self, onNext: { owner, profileData in
    //                guard let profileData else { return }
    //                owner.updateUI(profileData)
    //            }).disposed(by: disposeBag)
    //
    //        output.isTextCountExceeded
    //            .subscribe(with: self, onNext: { owner, isTextCountExceeded in
    //                if isTextCountExceeded { owner.updateTextField(owner.rootView.nameTextField) }
    //            }).disposed(by: disposeBag)
    //    }
    //}
    //
    ////MARK: - GalleryAlertControllerDelegate
    //
    //extension MyEditProfileViewController: GalleryAlertControllerDelegate {
    //    func galleryButtonDidTap() {
    //        present(imagePickerController, animated: true)
    //    }
    //
    //    func deleteButtonDidTap() {
    //        deleteProfileImageSubject.onNext(())
    //    }
    //}
    //
    ////MARK: - UIImagePickerControllerDelegate
    //
    //extension MyEditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    func imagePickerController(_ picker: UIImagePickerController,
    //                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //
    //        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
    //        selectProfileImageSubject.onNext(image)
    //        dismiss(animated: true)
    //    }
    //}
    //
    ////MARK: - 구역
    //
    //extension MyEditProfileViewController: ZoocAlertViewControllerDelegate {
    //    func exitButtonDidTap() {
    //        navigationController?.popViewController(animated: true)
    //    }
    //}
    //
    //extension MyEditProfileViewController {
    //    private func updateTextField(_ textField: ZoocEditTextField?) {
    //        guard let textField = textField else { return }
    //        let fixedText = textField.text?.substring(from: 0, to:textField.textFieldType.limit-1)
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now()) {
    //            self.rootView.nameTextField.text = fixedText
    //            guard let fixedText else { return }
    //
    //        }
    //    }
    //
    //    private func updateUI(_ editProfileData: EditProfileRequest) {
    //        print(editProfileData.nickName, editProfileData.nickName.count)
    //        rootView.nameTextField.text = editProfileData.nickName
    //        if editProfileData.profileImage != nil {
    //            rootView.profileImageButton.setImage(editProfileData.profileImage, for: .normal)
    //        } else {
    //            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
    //        }
    //    }
    //}
}
