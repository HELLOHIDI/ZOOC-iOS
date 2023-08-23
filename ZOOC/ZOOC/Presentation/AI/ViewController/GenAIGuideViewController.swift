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
    
    func showDenied() {
        let alert = UIAlertController(title: "사진이 부족합니다!", message: "사진 개수를 맞춰서 설정해주세요!", preferredStyle: .alert)
        
        let openSettingsAction = UIAlertAction(
            title: "사진 다시 고르기",
            style: .default) { action in
                self.selectPhoto()
            }
        
        let goBackAction = UIAlertAction(
            title: "나가기",
            style: .destructive
        )
        
        alert.addAction(openSettingsAction)
        alert.addAction(goBackAction)
        
        present(alert, animated: false, completion: nil)
    }
    
    func selectPhoto() {
        
    }
}
