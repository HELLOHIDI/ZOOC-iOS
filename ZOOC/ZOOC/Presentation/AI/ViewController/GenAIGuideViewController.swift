//
//  GenAIGuideViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/15.
//

import UIKit
import PhotosUI

import SnapKit
import Then

final class GenAIGuideViewController : BaseViewController {
    
    //MARK: - Properties
    
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
        
        target()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        viewModel.viewWillDisappearEvent()
    }
    
    //MARK: - Custom Method
    
    private func bind() {
        viewModel.enablePhotoUpload.observe(on: self) { [weak self] canUpload in
            guard let canUpload = canUpload else { return }
            if canUpload {
                self?.pushToGenAISelectImageVC()
            } else {
                self?.presentDenineGenerateAIViewController()
            }
        }
        
        viewModel.isPopped.observe(on: self) { [weak self] isPopped in
            if isPopped {
                self?.presentPHPickerViewController()
            }
        }
    }
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.xmarkButton.addTarget(self, action: #selector(xmarkButtonDidTap), for: .touchUpInside)
        rootView.selectImageButton.addTarget(self, action: #selector(selectImageButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func xmarkButtonDidTap() {
        presentLeavePageAlertVC()
    }
    
    @objc func selectImageButtonDidTap() {
        presentPHPickerViewController()
    }
}

extension GenAIGuideViewController {
    private func pushToGenAISelectImageVC() {
        let genAISelectImageVC = GenAISelectImageViewController(
            viewModel: DefaultGenAISelectImageViewModel(
                selectedImageDatasets: viewModel.selectedImageDatasets.value
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
        alertVC.exitButtonTapDelegate = self
        alertVC.modalPresentationStyle = .overFullScreen
        present(alertVC, animated: false)
    }
    
    private func presentDenineGenerateAIViewController() {
        let zoocAlertVC = ZoocAlertViewController(.shortOfPictures)
        zoocAlertVC.exitButtonTapDelegate = self
        zoocAlertVC.keepButtonTapDelegate = self
        zoocAlertVC.modalPresentationStyle = .overFullScreen
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
}

extension GenAIGuideViewController: ZoocAlertExitButtonTapGestureProtocol, ZoocAlertKeepButtonTapGestureProtocol {
    
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
    
    func keepButtonDidTap() {
        viewModel.keepButtonTapEvent()
        presentPHPickerViewController()
    }
}


extension GenAIGuideViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        viewModel.didFinishChoosingPhotosEvent(results: results)
    }
}
