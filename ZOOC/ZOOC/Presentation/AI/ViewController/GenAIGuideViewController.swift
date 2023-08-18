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
    
    private var petImageDatasets: [UIImage] = []
    
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
    
    private func pushToGenAISelectImageVC() {
        let genAISelectImageVC = GenAISelectImageViewController(
            viewModel: DefaultGenAISelectImageViewModel(
                petImageDatasets: petImageDatasets
            )
        )
        self.navigationController?.pushViewController(genAISelectImageVC, animated: true)
    }
    
    func showDenied() {
        let alert = UIAlertController(title: "사진이 부족합니다!", message: "사진 개수를 맞춰서 설정해주세요!", preferredStyle: .alert)
        
        let openSettingsAction = UIAlertAction(
            title: "사진 다시 고르기",
            style: .default) { action in
                self.presentPicker()
            }
        
        let goBackAction = UIAlertAction(
            title: "나가기",
            style: .destructive
        )
        
        alert.addAction(openSettingsAction)
        alert.addAction(goBackAction)
        
        present(alert, animated: false, completion: nil)
    }
}
extension GenAIGuideViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var selectedImages: [UIImage] = []
        
        // results 배열의 각 NSItemProvider에서 이미지를 로드하고 UIImage 객체로 변환하여 배열에 저장
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        selectedImages.append(image)
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if 8 <= selectedImages.count && selectedImages.count <= 15 {
                self.pushToGenAISelectImageVC()
            } else {
                self.showDenied()
            }
        }
    }
}
    
