//
//  MyEditPetProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/06/22.
//

import UIKit

import SnapKit
import Then

final class MyEditPetProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyEditPetProfileViewModel
    
    init(viewModel: MyEditPetProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var editPetProfileData = EditPetProfileRequest()
    
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
        viewModel.ableToEditPetProfile.observe(on: self) { [weak self] isEnabled in
            self?.updateButtonUI(isEnabled)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func style() {
        imagePickerController.do {
            $0.sourceType = .photoLibrary
        }
        rootView.nameTextField.text = viewModel.name
        
        if viewModel.photo != nil{
            rootView.profileImageButton.setImage(viewModel.photo, for: .normal)
        } else {
            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        }
        rootView.numberOfNameCharactersLabel.text = "\(viewModel.name.count)/4"
    }
    
    private func requestPatchPetAPI() {
        MyAPI.shared.patchPetProfile(requset: editPetProfileData, id: viewModel.id) { result in
            guard let result = self.validateResult(result) as? EditPetProfileResult else { return }
            print(result)
            NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
            NotificationCenter.default.post(name: .myPageUpdate, object: nil)
            
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
            
        }
    }
    
    //MARK: - Action Method
    
    @objc private func profileImageButtonDidTap() {
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
        guard let textField = notification.object as? MyEditTextField else { return }
        guard let text = textField.text else { return }
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...3:
            textFieldState = .isWritten
            viewModel.ableToEditPetProfile.value = true
        case 4...:
            textFieldState = .isFull
            let fixedText = text.substring(from: 0, to:3)
            textField.text = fixedText + " "
            
            let when = DispatchTime.now() + 0.01
            DispatchQueue.main.asyncAfter(deadline: when) {
                textField.text = fixedText
            }
            viewModel.ableToEditPetProfile.value = true
        default:
            textFieldState = .isEmpty
            viewModel.ableToEditPetProfile.value = false
        }
        updateTextFieldUI(textFieldState)
    }
    
    @objc func editCompleteButtonDidTap(){
        requestPatchPetAPI()
        rootView.completeButton.isEnabled = false
    }
}

extension MyEditPetProfileViewController {
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

//MARK: - GalleryAlertControllerDelegate

extension MyEditPetProfileViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        viewModel.deleteButtonDidTap()
    }
}

//MARK: - UIImagePickerControllerDelegate

extension MyEditPetProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.profileImageButton.setImage(image, for: .normal)
        viewModel.editPetProfileImageEvent(image)
        dismiss(animated: true)
    }
}

//MARK: - ZoocAlertViewControllerDelegate

extension MyEditPetProfileViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}

//MARK: - MyTextFieldDelegate
extension MyEditPetProfileViewController: MyTextFieldDelegate {
    func myTextFieldTextDidChange(_ textFieldType: MyEditTextField.TextFieldType, text: String) {
        self.viewModel.nameTextFieldDidChangeEvent(text)
        rootView.numberOfNameCharactersLabel.text =  text.count < 4 ? "\(text.count)/4" : "4/4"
    }
}
