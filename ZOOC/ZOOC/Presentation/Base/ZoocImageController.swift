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
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    var viewVelocity = CGPoint(x: 0, y: 0)
    
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
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
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
    
    
    @objc func handleDismiss(_ sender: UIPanGestureRecognizer) {
            
            viewTranslation = sender.translation(in: view)
            viewVelocity = sender.velocity(in: view)
            
            switch sender.state {
            case .changed:
                // 상하로 스와이프 할 때 위로 스와이프가 안되게 해주기 위해서 조건 설정
                if viewVelocity.y > 0 {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    })
                }
            case .ended:
                // 해당 뷰의 y값이 400보다 작으면(작게 이동 시) 뷰의 위치를 다시 원상복구하겠다. = 즉, 다시 y=0인 지점으로 리셋
                if viewTranslation.y < 250 {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.view.transform = .identity
                    })
                    // 뷰의 값이 400 이상이면 해당 화면 dismiss
                } else {
                    dismiss(animated: true, completion: nil)
                }
                
            default:
                break
            }
        }
        
        @IBAction func closeButton(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
        
}
