//
//  EditProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/04.
//

import UIKit

import SnapKit
import Then

final class MyEditProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyEditProfileViewModel
    
    init(viewModel: MyEditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var editMyProfileData = EditProfileRequest()
    
    //MARK: - UIComponents
    
    private lazy var rootView = MyEditProfileView()
    private let galleryAlertController = GalleryAlertController()
    private lazy var imagePickerController = UIImagePickerController()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        delegate()
        target()
        
        style()
    }
    
    //MARK: - Custom Method
    
    private func bind() {
        viewModel.ableToEditProfile.observe(on: self) { [weak self] isEnabled in
            self?.updateButtonUI(isEnabled)
        }
        
        viewModel.textFieldState.observe(on: self) { [weak self] state in
            self?.updateTextFieldUI(state) // 텍스트 필드 UI 업데이트
        }
    }
    
    private func delegate() {
        rootView.nameTextField.editDelegate = self
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
    }
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.completeButton.addTarget(self, action: #selector(editCompleteButtonDidTap), for: .touchUpInside)
        
        rootView.profileImageButton.addTarget(self, action: #selector(profileImageButtonDidTap) , for: .touchUpInside)
    }
    
    private func style() {
        imagePickerController.do { $0.sourceType = .photoLibrary }
        rootView.nameTextField.text = viewModel.name
        if viewModel.photo != nil {
            rootView.profileImageButton.setImage(viewModel.photo, for: .normal)
        } else {
            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        }
        rootView.numberOfNameCharactersLabel.text = "\(viewModel.name.count)/10"
    }
    
    private func requestPatchUserProfileAPI() {
        MyAPI.shared.patchMyProfile(requset: editMyProfileData) { result in
            self.validateResult(result)
            NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
            NotificationCenter.default.post(name: .myPageUpdate, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func profileImageButtonDidTap() {
        present(galleryAlertController,animated: true)
    }
    
    @objc func backButtonDidTap() {
        let zoocAlertVC = ZoocAlertViewController()
        zoocAlertVC.delegate = self
        zoocAlertVC.alertType = .leavePage
        zoocAlertVC.modalPresentationStyle = .overFullScreen
        present(zoocAlertVC, animated: false)
    }
    
    @objc func editCompleteButtonDidTap(){
        requestPatchUserProfileAPI()
    }
}

//MARK: - GalleryAlertControllerDelegate

extension MyEditProfileViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        viewModel.deleteButtonDidTap()
        rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension MyEditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.profileImageButton.setImage(image, for: .normal)
        viewModel.editProfileImageEvent(image)
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
        self.viewModel.nameTextFieldDidChangeEvent(text)

        if viewModel.isTextCountExceeded(for: textFieldType) {
            let fixedText = text.substring(from: 0, to:9)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.rootView.nameTextField.text = fixedText
            }
        }
        rootView.numberOfNameCharactersLabel.text =  text.count < 10 ? "\(text.count)/10" : "10/10"
    }
}

extension MyEditProfileViewController {
    private func updateButtonUI(_ isEnabled: Bool) {
        let backgroundColor: UIColor = isEnabled ? .zoocGradientGreen : .zoocGray1
        rootView.completeButton.backgroundColor = backgroundColor
        rootView.completeButton.isEnabled = isEnabled
    }
    
    private func updateTextFieldUI(_ textFieldState: BaseTextFieldState) {
        rootView.underLineView.backgroundColor = textFieldState.underLineColor
        rootView.nameTextField.textColor = textFieldState.textColor
        rootView.numberOfNameCharactersLabel.textColor = textFieldState.indexColor
    }
}
