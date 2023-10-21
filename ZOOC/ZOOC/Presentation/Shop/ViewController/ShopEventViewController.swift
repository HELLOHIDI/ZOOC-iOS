//
//  ShopEventVC.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/20.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ShopEventViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let backButton = UIButton()
    private let eventImageView = UIImageView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        
        bindUI()
    }
    
    //MARK: - Custom Method
    
    private func style() {
        backButton.do {
            $0.setImage(Image.back, for: .normal)
        }
        
        eventImageView.do {
            $0.image = Image.aiLogo
        }
    }
    
    private func hierarchy() {
        self.view.addSubviews(backButton, eventImageView)
    }
    
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        eventImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(477)
        }
    }
    
    private func bindUI() {
        self.rx.viewWillAppear.subscribe(with: self, onNext: { owner, _ in
            owner.getEventImage()
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        eventImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.eventImageViewDidTap()
            }).disposed(by: disposeBag)
    }
    
    private func eventImageViewDidTap() {
        let imageVC = ZoocImageViewController()
        imageVC.dataBind(image: eventImageView.image)
        imageVC.modalPresentationStyle = .overFullScreen
        present(imageVC, animated: true)
    }
    
    private func getEventImage() {
        ShopAPI.shared.getEventResult() { [weak self] result in
            guard let imageURL = self?.validateResult(result) as? String else { return }
            self?.eventImageView.kfSetImage(url: imageURL)
        }
    }
}
