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
            registerPetProfileImageButtonTapEvent: rootView.petProfileImageButton.rx.tap
                .flatMapLatest { [unowned self] _ in
                    return self.showImagePicker()
                }
            
            //            isTextCountExceeded: rootView.petProfileNameTextField.rx.textFieldType.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
//        var petId = BehaviorRelay<Int?>(value: nil)
//        var name = BehaviorRelay<String>(value: "")
//        var canRegisterPet = BehaviorRelay<Bool>(value: false)

        output.photo.asObservable().subscribe(onNext: { [weak self] photo in
            self?.rootView.petProfileImageButton.setImage(photo, for: .normal)
        }).disposed(by: disposeBag)
        
        output.textFieldState.asObservable().subscribe(onNext: { [weak self] textFieldState in
            self?.rootView.petProfileNameTextField.textColor = textFieldState.textColor
        }).disposed(by: disposeBag)
        
        output.isRegistedPet.asObservable().subscribe(onNext: { [weak self] isRegisted in
            if isRegisted { self?.pushToGenAIGuideVC() }
        }).disposed(by: disposeBag)
        
    }
    
    private func delegate() {
        rootView.petProfileNameTextField.editDelegate = self
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
    }
    
    private func target() {
        rootView.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        
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
}

//MARK: - GalleryAlertControllerDelegate

extension GenAIRegisterPetViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
//    func deleteButtonDidTap() {
//        rootView.petProfileImageButton.setImage(Image.defaultProfile, for: .normal)
//        //        viewModel.deleteButtonDidTap()
//    }
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

//MARK: - MyTextFieldDelegate

extension GenAIRegisterPetViewController: MyTextFieldDelegate {
    func myTextFieldTextDidChange(_ textFieldType: MyEditTextField.TextFieldType, text: String) {
        //        self.viewModel.nameTextFieldDidChangeEvent(text)
        
        //        if viewModel.isTextCountExceeded(for: textFieldType) {
        //            let fixedText = text.substring(from: 0, to:textFieldType.limit-1)
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
        //                self.rootView.petProfileNameTextField.text = fixedText
        //            }
        //        }
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
}

