//
//  AIViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

final class GenAIViewController : UIViewController{
    
    //MARK: - Properties
    
    let rootView = GenAIView()
    
    //MARK: - UI Components
    
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
    }
    
    //MARK: - Action Method
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
