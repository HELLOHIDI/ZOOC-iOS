//
//  ShopLoadingViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/21.
//

import UIKit

import SnapKit
import Then

final class ShopLoadingViewController: BaseViewController {
    
    //MARK: - Properties
    
    var petId: Int?
    
    //MARK: - UI Components
    
    private let rootView = ShopLoadingView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    init(_ petId: Int? = nil) {
        self.petId = petId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNotificationCenter()
    }
    
    //MARK: - Custom Method
    
    private func setUI() {
        rootView.activityIndicatorView.startAnimating()
    }
    
    private func setNotificationCenter() {
        print(#function)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pushToShopVC),
            name: .dataSetUploadSuccess,
            object: nil
        )
    }
    
    @objc func pushToShopVC() {
        rootView.activityIndicatorView.stopAnimating()
        
        let shopVC = ShopViewController(viewModel: ShopViewModel.init(petId))
        shopVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(shopVC, animated: true)
    }
}
