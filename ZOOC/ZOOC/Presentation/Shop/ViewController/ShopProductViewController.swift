//
//  ShopProductViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

import RxCocoa
import RxSwift

final class ShopProductViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: ShopProductViewModel
    private let disposeBag = DisposeBag()
    
    private let cartButtonDidTap = PublishRelay<[SelectedProductOption]>()
    private let orderButtonDidTap = PublishRelay<[SelectedProductOption]>()
    
    
    //MARK: - UI Components
    
    private let rootView = ShopProductView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    init(viewModel: ShopProductViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setDelegate()
        bindUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Custom Method

    private func setDelegate() {
        rootView.productBottomSheet.delegate = self
    }
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.cartButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let cartVC = ShopCartViewController(viewModel: ShopCartViewModel(service: DefaultRealmService()))
                owner.navigationController?.pushViewController(cartVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.buyButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.present(owner.rootView.productBottomSheetVC, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        let input = ShopProductViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            cartButtonDidTap: cartButtonDidTap.asObservable(),
            orderButtonDidTap: orderButtonDidTap.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.productDetailData
            .asDriver(onErrorJustReturn: .init())
            .drive(with: self, onNext: { owner, data in
                owner.rootView.updateUI(data)
                owner.rootView.productBottomSheet.dataBind(data)
            })
            .disposed(by: disposeBag)
        
        output.productImagesData
            .asDriver(onErrorJustReturn: [])
            .drive(
                rootView.imageCollectionView.rx.items(cellIdentifier:
                                                        ProductImageCollectionViewCell.reuseCellIdentifier,
                                                      cellType: ProductImageCollectionViewCell.self)
            ) { row, data, cell in
                cell.dataBind(data)
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .asDriver(onErrorJustReturn: .unknown)
            .drive(with: self, onNext: { owner, toast in
                owner.showToast(toast)
            })
            .disposed(by: disposeBag)
        
        output.pushToOrderVC
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, orderProducts in
                let orderVC = OrderViewController(orderProducts, realmService: DefaultRealmService())
                owner.navigationController?.pushViewController(orderVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}


//MARK: - ProductBottomSheetDelegate

extension ShopProductViewController: ProductBottomSheetDelegate {
    
    func cartButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        cartButtonDidTap.accept(selectedProductOptions)
    }
    
    func orderButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        orderButtonDidTap.accept(selectedProductOptions)
    }
}


