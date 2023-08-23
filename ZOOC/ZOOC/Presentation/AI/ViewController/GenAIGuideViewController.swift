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
    
    private var selectedImageDatasets: [PHPickerResult] = []
    
    //MARK: - UI Components
    
    let rootView = GenAIGuideView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        selectedImageDatasets = []
    }
    
    //MARK: - Custom Method
    
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
                selectedImageDatasets: selectedImageDatasets
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
        alertVC.modalPresentationStyle = .overFullScreen
        present(alertVC, animated: false)
    }
    
    private func presentDenineGenerateAIViewController() {
        let zoocAlertVC = ZoocAlertViewController(.shortOfPictures)
        zoocAlertVC.delegate = self
        zoocAlertVC.modalPresentationStyle = .overFullScreen
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
}

extension GenAIGuideViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}

extension GenAIGuideViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            selectedImageDatasets.append(result)
        }
        
        if 8 <= self.selectedImageDatasets.count && self.selectedImageDatasets.count <= 15 {
            self.pushToGenAISelectImageVC()
        } else {
            self.presentDenineGenerateAIViewController()
        }
    }
}
