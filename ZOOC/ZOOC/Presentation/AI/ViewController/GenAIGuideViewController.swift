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

final class GenAIGuideViewController : BaseViewController {
    
    //MARK: - Properties
    
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
        
        setNotification()
    }

    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.xmarkButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentLeavePageAlertVC()
            }).disposed(by: disposeBag)
        
        rootView.selectImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentPHPickerViewController()
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = GenAIGuideViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            viewWillDisappearEvent: self.rx.viewWillDisappear.asObservable(),
            didFinishPickingImageEvent: pickedImageSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.ableToPhotoUpload
            .subscribe(with: self, onNext: { owner, canUpload in
                guard let canUpload = canUpload else { return }
                if canUpload { owner.pushToGenAISelectImageVC()}
                else { owner.presentDenineGenerateAIViewController() }
            }).disposed(by: disposeBag)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reselectImage),
            name: Notification.Name("reselectImage"),
            object: nil
        )
    }
    
    @objc func reselectImage() {
        presentPHPickerViewController()
    }
}

extension GenAIGuideViewController {
    private func pushToGenAISelectImageVC() {
        let genAISelectImageVC = GenAISelectImageViewController(
            viewModel: GenAISelectImageViewModel(
                genAISelectImageUseCase: DefaultGenAISelectImageUseCase(
                    petId: viewModel.getPetId(),
                    selectedImageDatesets: viewModel.getSelectedImageDatasets(),
                    repository: DefaultGenAIModelRepository()
                )
            )
        )
        self.navigationController?.pushViewController(genAISelectImageVC, animated: true)
    }
    
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
        self.navigationController?.popToRootViewController(animated: true)
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
