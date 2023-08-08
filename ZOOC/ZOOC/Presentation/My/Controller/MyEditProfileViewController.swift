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
    }
    
    private func updateButtonUI(_ isEnabled: Bool) {
        let backgroundColor: UIColor = isEnabled ? .zoocGradientGreen : .zoocGray1
        rootView.completeButton.backgroundColor = backgroundColor
        rootView.completeButton.isEnabled = isEnabled
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func style() {
        imagePickerController.do { 
            $0.sourceType = .photoLibrary
        }
        
        rootView.numberOfNameCharactersLabel.text = "\(rootView.nameTextField.text!.count)/10"
    }

    func dataBind(data: UserResult?) {
        rootView.nameTextField.text = data?.nickName
        editMyProfileData.nickName = data?.nickName ?? ""
        
        if let photoURL = data?.photo{
            rootView.profileImageButton.kfSetButtonImage(url: photoURL)
        } else {
            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        }
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
    
    @objc private func textDidChange(_ notification: Notification) {
        guard let textField = notification.object as? BaseTextField else { return }
        guard let text = textField.text else { return }
        var textFieldState: BaseTextFieldState
        var limit: Int = 0
        switch textField.textFieldType {
        case .profile:
            limit = 4
        case .pet:
            limit = 10
        }
        switch text.count {
        case 1...limit-1:
            textFieldState = .isWritten
        case limit...:
            textFieldState = .isFull
            let fixedText = text.substring(from: 0, to:limit-1)
            textField.text = fixedText + " "
            
            let when = DispatchTime.now() + 0.01
            DispatchQueue.main.asyncAfter(deadline: when) {
                textField.text = fixedText
            }
        default:
            textFieldState = .isEmpty
        }
        
        textFieldState.setTextFieldState(
            textField: nil,
            underLineView: rootView.underLineView,
            label: rootView.numberOfNameCharactersLabel
        )
        setTextFieldText(textCount: text.count)
        
    }
    
    @objc func editCompleteButtonDidTap(){
        guard let nickName = rootView.nameTextField.text else { return }
        self.editMyProfileData.nickName = nickName
        requestPatchUserProfileAPI()
    }
}

extension MyEditProfileViewController {
    func setTextFieldText(textCount: Int) {
        rootView.numberOfNameCharactersLabel.text =  textCount < 10 ? "\(textCount)/10" : "10/10"
    }
}

//MARK: - GalleryAlertControllerDelegate

extension MyEditProfileViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        editMyProfileData.hasPhoto = false
    }
}

//MARK: - UIImagePickerControllerDelegate

extension MyEditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.profileImageButton.setImage(image, for: .normal)
        editMyProfileData.profileImage = image
        rootView.completeButton.isEnabled = true
        
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
        print(#function)
        self.viewModel.nameTextFieldDidChangeEvent(text)
    }
}
