//
//  GenAIGuideViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/15.
//

import UIKit
import PhotosUI

import RxSwift
import RxCocoa
import SnapKit
import Then

final class GenAIGuideViewController : BaseViewController {
    
    //MARK: - Properties
    
    var petId: Int?
    private let disposeBag = DisposeBag()
    private let pickedImageSubject = PublishSubject<[PHPickerResult]>()
    let viewModel: GenAIGuideViewModel
    
    //MARK: - UI Components
    
    let rootView = GenAIGuideView()
    
    //MARK: - Life Cycle
    
    init(viewModel: GenAIGuideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        bindViewModel()
    }

    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.xmarkButton.rx.tap.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.presentLeavePageAlertVC()
            }).disposed(by: disposeBag)
        
        rootView.selectImageButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.presentPHPickerViewController()
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = GenAIGuideViewModel.Input(
            viewWillDisappearEvent: self.rx.viewWillDisappear.asObservable(),
            didFinishPickingImageEvent: pickedImageSubject.asObservable()
            )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.ableToPhotoUpload
            .withUnretained(self)
            .subscribe(onNext: { owner, canUpload in
                guard let canUpload = canUpload else { return }
                if canUpload { owner.pushToGenAISelectImageVC()}
                else { owner.presentDenineGenerateAIViewController() }
            }).disposed(by: disposeBag)
        
//        viewModel.isPopped.observe(on: self) { [weak self] isPopped in
//            if isPopped {
//                self?.presentPHPickerViewController()
//            }
//        }
    }
}

extension GenAIGuideViewController {
    private func pushToGenAISelectImageVC() {
        guard let petId = self.petId else { return }
        let genAISelectImageVC = GenAISelectImageViewController(
            viewModel: DefaultGenAISelectImageViewModel(
                petId: petId,
                selectedImageDatasets: viewModel.getSelectedImageDatasets(),
                repository: GenAIModelRepositoryImpl()
            )
        )
        self.navigationController?.pushViewController(genAISelectImageVC, animated: true)
    }
}

extension GenAIGuideViewController {
    private func presentPHPickerViewController() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 15
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    private func presentLeavePageAlertVC() {
        let alertVC = ZoocAlertViewController.init(.leavePage)
        alertVC.delegate = self
        present(alertVC, animated: false)
    }
    
    private func presentDenineGenerateAIViewController() {
        let zoocAlertVC = ZoocAlertViewController(.shortOfPictures)
        zoocAlertVC.delegate = self
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
}

extension GenAIGuideViewController: ZoocAlertViewControllerDelegate {
    
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
    
    func keepButtonDidTap() {
        presentPHPickerViewController()
    }
}


extension GenAIGuideViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        pickedImageSubject.onNext(results)
    }
}
