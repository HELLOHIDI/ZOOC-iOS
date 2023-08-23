//
//  AIViewController.swift
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
    
    //MARK: - Custom Method
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.selectImageButton.addTarget(self, action: #selector(selectImageButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectImageButtonDidTap() {
        selectPhoto()
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
    
    func selectPhoto() {
        presentPicker()
    }
}
extension GenAIGuideViewController {
    private func presentPicker() {
        // PHPickerConfiguration 생성 및 정의
        var config = PHPickerConfiguration()
        // 라이브러리에서 보여줄 Assets을 필터를 한다. (기본값: 이미지, 비디오, 라이브포토)
        config.filter = .images
        // 다중 선택 갯수 설정 (0 = 무제한)
        config.selectionLimit = 15
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    private func presentZoocAlertVC() {
        let alertVC = ZoocAlertViewController.init(.leavePage)
        alertVC.delegate = self
        alertVC.modalPresentationStyle = .overFullScreen
        present(alertVC, animated: false)
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
            self.presentZoocAlertVC()
        }
       
    }
}
//// results 배열의 각 NSItemProvider에서 이미지를 로드하고 UIImage 객체로 변환하여 배열에 저장
//let group = DispatchGroup()
//
//for result in results {
//    group.enter()
//    let itemProvider = result.itemProvider
//
//    if itemProvider.canLoadObject(ofClass: UIImage.self) {
//        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
//            if let image = object as? UIImage {
//                self?.selectedImageDatasets.append(image)
//            }
//            group.leave()
//        }
//    } else {
//        group.leave()
//    }
//}
//
//group.notify(queue: .main) {
//    if 8 <= self.selectedImageDatasets.count && self.selectedImageDatasets.count <= 15 {
//        self.pushToGenAISelectImageVC()
//    } else {
//        self.presentZoocAlertVC()
//    }
//}
