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
    
    private let viewModel: GenAIRegisterViewModel
    
    init(viewModel: GenAIRegisterViewModel) {
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
        viewModel.ableToEditPetProfile.observe(on: self) { [weak self] isEnabled in
            self?.rootView.completeButton.isEnabled = isEnabled
        }
        
        viewModel.textFieldState.observe(on: self) { [weak self] state in
            self?.updateTextFieldUI(state)
        }
        
        viewModel.registerCompletedOutput.observe(on: self) { [weak self] isSuccess in
            guard let isSuccess else { return }
            if isSuccess {
                self?.pushToGenAIGuideVC()
            } else {
                self?.showToast("다시 시도해주세요.", type: .bad)
            }
        }
    }
    
    private func delegate() {
        rootView.petProfileNameTextField.editDelegate = self
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
    }
    
    private func target() {
        rootView.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        
        rootView.completeButton.addTarget(self, action: #selector(registerPetButtonDidTap), for: .touchUpInside)
        
        rootView.petProfileImageButton.addTarget(self, action: #selector(profileImageButtonDidTap) , for: .touchUpInside)
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
    
    @objc func cancelButtonDidTap() {
        presentZoocAlertVC()
    }
    
    @objc func registerPetButtonDidTap(){
        rootView.completeButton.isEnabled = false
        viewModel.registerPetButtonDidTap()
    }
}

//MARK: - GalleryAlertControllerDelegate

extension GenAIRegisterPetViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        rootView.petProfileImageButton.setImage(Image.defaultProfile, for: .normal)
        viewModel.deleteButtonDidTap()
    }
}

//MARK: - UIImagePickerControllerDelegate

extension GenAIRegisterPetViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.petProfileImageButton.setImage(image, for: .normal)
        viewModel.registerPetProfileImageEvent(image)
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
                self.rootView.petProfileNameTextField.text = fixedText
            }
        }
    }
}

extension GenAIRegisterPetViewController {
    private func updateTextFieldUI(_ textFieldState: BaseTextFieldState) {
        rootView.petProfileNameTextField.textColor = textFieldState.textColor
    }
    
    private func presentZoocAlertVC() {
        let alertVC = ZoocAlertViewController.init(.leavePage)
        alertVC.delegate = self
        present(alertVC, animated: false)
    }
    
    private func pushToGenAIGuideVC() {
        let genAIGuideVC = GenAIGuideViewController(
            viewModel: DefaultGenAIGuideViewModel()
        )
        genAIGuideVC.hidesBottomBarWhenPushed = true
        genAIGuideVC.petId = viewModel.petId.value
        navigationController?.pushViewController(genAIGuideVC, animated: true)
    }
}
