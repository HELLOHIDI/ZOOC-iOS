//
//  GenAIRegisterPetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

final class GenAIRegisterPetViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: GentAIRegisterViewModel
    
    init(viewModel: GentAIRegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIComponents
    
    private lazy var rootView = GenAIRegisterPetView()
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
        viewModel.editPetProfileDataOutput.observe(on: self) { [weak self] editPetProfileData in
            self?.updateUI(editPetProfileData)
        }
        
        viewModel.ableToEditPetProfile.observe(on: self) { [weak self] isEnabled in
            self?.rootView.completeButton.isEnabled = isEnabled
        }
        
        viewModel.textFieldState.observe(on: self) { [weak self] state in
            self?.updateTextFieldUI(state)
        }
        
        viewModel.editCompletedOutput.observe(on: self) { [weak self] isSuccess in
            guard let isSuccess else { return }
            if isSuccess {
                if let navigationController = self?.navigationController {
                    navigationController.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            } else {
                self?.presentBottomAlert("다시 시도해주세요")
            }
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
        imagePickerController.do {
            $0.sourceType = .photoLibrary
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
    
    @objc func editCompleteButtonDidTap(){
       // viewModel.patchPetProfile()
    }
}

//MARK: - GalleryAlertControllerDelegate

extension GenAIRegisterPetViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        viewModel.deleteButtonDidTap()
    }
}

//MARK: - UIImagePickerControllerDelegate

extension GenAIRegisterPetViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.profileImageButton.setImage(image, for: .normal)
        viewModel.editPetProfileImageEvent(image)
        dismiss(animated: true)
    }
}

//MARK: - ZoocAlertViewControllerDelegate

extension GenAIRegisterPetViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}

//MARK: - MyTextFieldDelegate

extension GenAIRegisterPetViewController: MyTextFieldDelegate {
    func myTextFieldTextDidChange(_ textFieldType: MyEditTextField.TextFieldType, text: String) {
        self.viewModel.nameTextFieldDidChangeEvent(text)
        
        if viewModel.isTextCountExceeded(for: textFieldType) {
            let fixedText = text.substring(from: 0, to:textFieldType.limit-1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.rootView.nameTextField.text = fixedText
            }
        }
    }
}

extension GenAIRegisterPetViewController {
    private func updateTextFieldUI(_ textFieldState: BaseTextFieldState) {
        rootView.underLineView.backgroundColor = textFieldState.underLineColor
        rootView.nameTextField.textColor = textFieldState.textColor
        rootView.numberOfNameCharactersLabel.textColor = textFieldState.indexColor
    }
    
    private func updateUI(_ editProfileData: EditPetProfileRequest) {
        rootView.nameTextField.text = editProfileData.nickName
        if editProfileData.file != nil {
            rootView.profileImageButton.setImage(editProfileData.file, for: .normal)
        } else {
            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        }
        rootView.numberOfNameCharactersLabel.text = "\(editProfileData.nickName.count)/4"
    }
}
