//
//  ZoocImageController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/24.
//

import UIKit

import SnapKit
import Then

final class ZoocImageViewController : BaseViewController {
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let dismissButton = UIButton()
    private let imageView = UIImageView()
    private let etcButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        addPanDismissGesture()
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        
        view.backgroundColor = .black
    
        dismissButton.do {
            $0.setImage(Image.xmarkWhite, for: .normal)
            $0.addTarget(self,
                         action: #selector(dismissButtonDidTap),
                         for: .touchUpInside)
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        etcButton.do {
            $0.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            $0.tintColor = .white
            $0.addTarget(self,
                         action: #selector(etcButtonDidTap),
                         for: .touchUpInside)
        }
    }
    
    private func hierarchy() {
        view.addSubviews(dismissButton,
                         imageView,
                         etcButton)
    }
    
    private func layout() {
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        etcButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(42)
        }
    }
    
    
    func dataBind(image: UIImage?) {
        imageView.image = image
    }
    
    //MARK: - Action Method
    
    @objc
    private func dismissButtonDidTap() {
        dismiss(animated: true)
    }
    
    @objc
    private func etcButtonDidTap() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let saveAction =  UIAlertAction(title: "저장하기", style: .default) { action in
            guard let image = self.imageView.image else { return }
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           #selector(self.saveCompleted),
                                           nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

    
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
    
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                print("Oops\(error)")
            } else {
                presentBottomAlert("사진이 저장되었습니다.")
            }
        }
}
