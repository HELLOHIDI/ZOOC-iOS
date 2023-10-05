//
//  ShopViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import RxCocoa
import RxSwift

final class ShopViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: ShopViewModel
    private let disposeBag = DisposeBag()
    
    private let rootView = ShopView()
    private let refreshControl = UIRefreshControl()

    //MARK: - Life Cycle
    
    init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindUI()
        bindViewModel()
        rootView.collectionView.refreshControl = refreshControl
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    //MARK: - Custom Method
    
    func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.cartButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let cartVC = ShopCartViewController(viewModel: ShopCartViewModel())
                cartVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(cartVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(with: self, onNext: { owner, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    owner.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = ShopViewModel.Input(
            viewDidLoadEvent:
                self.rx.viewDidLoad.asObservable(),
            refreshValueChangedEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            productCellDidSelectEvent:  self.rootView.collectionView.rx.modelSelected(ProductResult.self).asObservable()
        )
        
        let output = self.viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.productData
            .asDriver(onErrorJustReturn: [])
            .drive(
                rootView.collectionView.rx.items(
                    cellIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier,
                    cellType: ShopProductCollectionViewCell.self)
            ) { row, data, cell in
                cell.dataBind(data: data)
            }
            .disposed(by: disposeBag)
            
        output.pushShopProductVC
            .asDriver(onErrorJustReturn: ShopProductModel())
            .drive(with: self, onNext: { owner, model in
                let productVC = ShopProductViewController(viewModel: ShopProductViewModel(model: model))
                owner.navigationController?.pushViewController(productVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .asDriver(onErrorJustReturn: .unknown)
            .drive(with: self, onNext: { owner, toast in
                owner.showToast(toast, bottomInset: 40)
            })
            .disposed(by: disposeBag)
    }
    
}
