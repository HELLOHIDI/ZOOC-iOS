//
//  ShopCartViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/05.
//

import UIKit

import RxCocoa
import RxSwift

final class ShopCartViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: ShopCartViewModel
    private let rootView = ShopCartView()
    private let disposeBag = DisposeBag()
    
    private let adjustAmountButtonDidTapEvent = PublishRelay<(Int, Bool)>()
    private let deleteButtonDidTapEvent = PublishRelay<Int>()
    
    
    //MARK: - Life Cycle
    
    init(viewModel: ShopCartViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        bindUI()
        bindViewModel()
    }
    
    override func loadView() {
        self.view = rootView
        
        dismissKeyboardWhenTappedAround()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        Observable.merge(rootView.backButton.rx.tap.asObservable(),
                         rootView.emptyCartButton.rx.tap.asObservable())
        .subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
            
        })
        .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = ShopCartViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asObservable(),
            orderButtonDidTapEvent: rootView.orderButton.rx.tap.asObservable(),
            cellAdjustAmountButtonDidTapEvent: adjustAmountButtonDidTapEvent.asObservable(),
            cellDeleteButtonDidTapEvent: deleteButtonDidTapEvent.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)

        Observable.combineLatest(output.deliveryFee, output.cartedProductsData)
            .asDriver(onErrorJustReturn: (Int(), []))
            .drive(onNext: { [weak self] fee, cartedProducts in
                self?.rootView.updateUI(cartedProducts, deliveryFee: fee)
            })
            .disposed(by: disposeBag)
        
        output.cartedProductsData
            .asDriver(onErrorJustReturn: [])
            .drive(rootView.collectionView.rx.items(cellIdentifier: ShopCartCollectionViewCell.reuseCellIdentifier,
                                                    cellType: ShopCartCollectionViewCell.self)
            ) { row, data, cell in
                cell.dataBind(row: row, selectedOption: data)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        output.pushOrderVC
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, orderProducts in
                let orderVC = OrderViewController(orderProducts)
                owner.navigationController?.pushViewController(orderVC, animated: true)
            })
            .disposed(by: disposeBag)
            
    }
}


//MARK: - ShopCartCollectionViewCellDelegate

extension ShopCartViewController: ShopCartCollectionViewCellDelegate {
    func adjustAmountButtonDidTap(row: Int, isPlus: Bool) {
        adjustAmountButtonDidTapEvent.accept((row,isPlus))
    }
    
    func xButtonDidTap(row: Int) {
        let zoocAlertVC = ZoocAlertViewController(.deleteProduct)
        zoocAlertVC.delegate = self
        zoocAlertVC.dataBind(row)
        present(zoocAlertVC, animated: false)
    }
    
}

//MARK: - ZoocAlertViewControllerDelegate

extension ShopCartViewController: ZoocAlertViewControllerDelegate {
    
    internal func keepButtonDidTap(_ data: Any?) {
        guard let row = data as? Int else { return }
        deleteButtonDidTapEvent.accept(row)
        
    }
}
