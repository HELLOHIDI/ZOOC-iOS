//
//  GenAICompletedViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/16.
//

import UIKit

final class GenAICompletedViewController : UIViewController {
    
    //MARK: - Properties
    
    let rootView = GenAICompletedView()
    
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
        rootView.cancelButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.goShopButton.addTarget(self, action: #selector(goShopButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc func backButtonDidTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func goShopButtonDidTap() {
        //        let shopChoosePetVC = ShopChoosePetViewController(
        //            viewModel: GenAIChoosePetModel(
        //                repository: GenAIPetRepositoryImpl()
        //            )
        //        )
        //        self.navigationController?.pushViewController(shopChoosePetVC, animated: true)
        //    }
    }
}
