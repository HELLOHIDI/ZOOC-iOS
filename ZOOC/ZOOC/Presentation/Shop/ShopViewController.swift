//
//  ShopViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

final class ShopViewController : BaseViewController {
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private lazy var myButton: UIButton = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self,
                         action: #selector(myButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        
    }
    
    private func hierarchy() {
        view.addSubview(myButton)
    }
    
    private func layout() {
        
        myButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(60)
        }
        
    }
    
    //MARK: - Action Method
    
    @objc
    private func myButtonDidTap() {
        ShopAPI.shared.getProducts { result in
            guard let result = self.validateResult(result) as? [ProductResult] else {return}
            
            dump(result)
        }
    }
    
}
