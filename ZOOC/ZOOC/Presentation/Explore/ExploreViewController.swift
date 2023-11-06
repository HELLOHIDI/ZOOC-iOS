//
//  ExploreViewController.swift
//  ZOOC
//
//  Created by 장석우 on 11/6/23.
//

import UIKit

import SnapKit

final class ExploreViewController : BaseViewController {
    
    //MARK: - Properties
    
    private let imageView = UIImageView()
    
    //MARK: - UI Components
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
    }
    
    //MARK: - Custom Method
    
    
    private func style() {
        view.backgroundColor = .zw_background
        
        imageView.image = .zwImage(.graphics_notyet)
        imageView.contentMode = .scaleAspectFit
    }
    
    private func hierarchy() {
        view.addSubview(imageView)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(76)
            $0.height.equalTo(260.adjusted)
            $0.centerY.equalToSuperview().offset(-25)
        }
    }
    
    //MARK: - Action Method
    
}
