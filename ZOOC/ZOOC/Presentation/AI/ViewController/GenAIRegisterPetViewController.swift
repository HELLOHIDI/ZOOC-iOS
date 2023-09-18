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
        let input = GenAIRegisterPetViewModel.Input(
            nameTextFieldDidChangeEvent: rootView.petProfileNameTextField.rx.text.asObservable(),
            registerPetButtonTapEvent: self.rootView.completeButton.rx.tap.asObservable(),
            deleteButtonTapEvent: self.rootView.petProfileImageButton.rx.tap.asObservable(),
            registerPetProfileImageButtonTapEvent: self.rootView.petProfileImageButton.rx.tap.flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            }
            .map { info in
                return info[.originalImage] as? UIImage
            }
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.photo.subscribe(onNext: { [weak self] photo in
            self?.rootView.petProfileImageButton.setImage(photo, for: .normal)
        }).disposed(by: disposeBag)
        
        output.textFieldState.subscribe(onNext: { [weak self] textFieldState in
            self?.rootView.petProfileNameTextField.textColor = textFieldState.textColor
        }).disposed(by: disposeBag)
        
        output.isRegistedPet.subscribe(onNext: { [weak self] isRegisted in
            if isRegisted { self?.pushToGenAIGuideVC() }
        }).disposed(by: disposeBag)
        
        output.isTextCountExceeded.subscribe(onNext: { [weak self] isTextCountExceeded in
            if isTextCountExceeded { self?.updateTextField(self?.rootView.petProfileNameTextField) }
        }).disposed(by: disposeBag)
    }
    
    private func delegate() {
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
    }
    
    private func target() {
        rootView.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
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
        //        viewModel.registerPetProfileImageEvent(image)
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
    
    private func showImagePicker() -> Observable<UIImage> {
        //        return Observable.create { [unowned self] observer in
        //            self.imagePickerController.rx.image
        //                .subscribe(onNext: { image in
        //                    observer.onNext(image)
        //                    observer.onCompleted()
        //                }, onError: { error in
        //                    observer.onError(error)
        //                })
        //                .disposed(by: self.disposeBag)
        //
        //            self.present(self.imagePickerController, animated: true, completion: nil)
        
        return Disposables.create() as! Observable<UIImage>
    }
    
    private func updateTextField(_ textField: MyEditTextField?) {
        guard let textField = textField else { return }
        let fixedText = textField.text?.substring(from: 0, to:textField.textFieldType.limit-1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.rootView.petProfileNameTextField.text = fixedText
        }
    }
}

