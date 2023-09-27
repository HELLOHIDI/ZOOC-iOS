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
    
    init(viewModel: MyEditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIComponents
    
    private lazy var rootView = MyEditProfileView()
    private var galleryAlertController: GalleryAlertController {
        let galleryAlertController = GalleryAlertController()
        return galleryAlertController
    }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        rootView.nameTextField.editDelegate = self
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
    }
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let zoocAlertVC = ZoocAlertViewController(.leavePage)
                zoocAlertVC.delegate = self
                owner.present(zoocAlertVC, animated: false)
            }).disposed(by: disposeBag)
        
        rootView.profileImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.present(owner.galleryAlertController,animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyEditProfileViewModel.Input(
            nameTextFieldDidChangeEvent: rootView.nameTextField.rx.text.asObservable(),
            editButtonTapEvent: self.rootView.completeButton.rx.tap.asObservable().map { [weak self] _ in
                self?.rootView.profileImageButton.currentImage ?? Image.defaultProfile
            }
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.ableToEditProfile
            .asDriver()
            .drive(with: self, onNext: { owner, canEdit in
                owner.rootView.completeButton.isEnabled = canEdit
            }).disposed(by: disposeBag)
        
        output.textFieldState
            .asDriver()
            .drive(with: self, onNext: { owner, state in
                owner.updateTextFieldUI(state)
            }).disposed(by: disposeBag)
        
        output.isEdited
            .asDriver()
            .drive(with: self, onNext: { owner, isEdited in
                guard let isEdited = isEdited else { return }
                if isEdited { owner.navigationController?.popViewController(animated: true) }
                else { owner.showToast("다시 시도해주세요", type: .bad)}
            }).disposed(by: disposeBag)
        
        output.profileData
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, profileData in
                guard let profileData = profileData else { return }
                owner.updateUI(profileData)
            }).disposed(by: disposeBag)
    }
}

//MARK: - GalleryAlertControllerDelegate

extension MyEditProfileViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        print(#function)
    }
    
    func deleteButtonDidTap() {
        print(#function)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension MyEditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.profileImageButton.setImage(image, for: .normal)
//        viewModel.editProfileImageEvent(image)
        dismiss(animated: true)
    }
}

//MARK: - 구역

extension MyEditProfileViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension MyEditProfileViewController: MyTextFieldDelegate {
    func myTextFieldTextDidChange(_ textFieldType: MyEditTextField.TextFieldType, text: String) {
//        self.viewModel.nameTextFieldDidChangeEvent(text)

//        if viewModel.isTextCountExceeded(for: textFieldType) {
//            let fixedText = text.substring(from: 0, to:textFieldType.limit-1)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                self.rootView.nameTextField.text = fixedText
//            }
//        }
    }
}

extension MyEditProfileViewController {
    private func updateTextFieldUI(_ textFieldState: BaseTextFieldState) {
        rootView.underLineView.backgroundColor = textFieldState.underLineColor
        rootView.nameTextField.textColor = textFieldState.textColor
        rootView.numberOfNameCharactersLabel.textColor = textFieldState.indexColor
    }
    
    private func updateUI(_ editProfileData: EditProfileRequest) {
        rootView.nameTextField.text = editProfileData.nickName
        if editProfileData.profileImage != nil {
            rootView.profileImageButton.setImage(editProfileData.profileImage, for: .normal)
        } else {
            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        }
        rootView.numberOfNameCharactersLabel.text = "\(editProfileData.nickName.count)/10"
    }
}
