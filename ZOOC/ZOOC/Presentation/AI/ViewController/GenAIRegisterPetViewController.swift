//
//  GenAIRegisterPetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

final class GenAIRegisterPetViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: GenAIRegisterPetViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GenAIRegisterPetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIComponents
    
    private lazy var rootView = GenAIRegisterPetView()
    
    private var galleryAlertController: GalleryAlertController {
        let galleryAlertController = GalleryAlertController()
        galleryAlertController.delegate = self
        return galleryAlertController
    }
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        bindViewModel()
    }
    
    private func bindUI() {
        rootView.cancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else{ return }
            self.presentZoocAlertVC()
        }).disposed(by: disposeBag)
        
        rootView.petProfileImageButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.present(self.galleryAlertController, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = GenAIRegisterPetViewModel.Input(
            nameTextFieldDidChangeEvent: rootView.petProfileNameTextField.rx.text.asObservable(),
            registerPetButtonTapEvent: self.rootView.completeButton.rx.tap.asObservable().map { [weak self] _ in
                self?.rootView.petProfileImageButton.currentImage ?? Image.cameraCircle
            }
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.canRegisterPet.subscribe(onNext: { [weak self] canRegister in
            self?.rootView.completeButton.isEnabled = canRegister
        }).disposed(by: disposeBag)
        
        output.textFieldState.subscribe(onNext: { [weak self] textFieldState in
            self?.rootView.petProfileNameTextField.textColor = textFieldState.textColor
        }).disposed(by: disposeBag)
        
        output.isRegistedPet.subscribe(onNext: { [weak self] isRegisted in
            if isRegisted { self?.pushToGenAIGuideVC() }
            else { self?.rootView.completeButton.isEnabled = true }
        }).disposed(by: disposeBag)
        
        output.isTextCountExceeded.subscribe(onNext: { [weak self] isTextCountExceeded in
            if isTextCountExceeded { self?.updateTextField(self?.rootView.petProfileNameTextField) }
        }).disposed(by: disposeBag)
    }
}

//MARK: - GalleryAlertControllerDelegate

extension GenAIRegisterPetViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }

    func deleteButtonDidTap() {
        rootView.petProfileImageButton.setImage(Image.defaultProfile, for: .normal)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension GenAIRegisterPetViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.petProfileImageButton.setImage(image, for: .normal)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - ZoocAlertViewControllerDelegate

extension GenAIRegisterPetViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}

extension GenAIRegisterPetViewController {
    
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
        genAIGuideVC.petId = viewModel.getPetId().value
        navigationController?.pushViewController(genAIGuideVC, animated: true)
    }
    
    private func updateTextField(_ textField: MyEditTextField?) {
        guard let textField = textField else { return }
        let fixedText = textField.text?.substring(from: 0, to:textField.textFieldType.limit-1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.rootView.petProfileNameTextField.text = fixedText
        }
    }
}

