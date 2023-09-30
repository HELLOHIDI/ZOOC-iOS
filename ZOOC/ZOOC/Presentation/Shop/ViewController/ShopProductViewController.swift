//
//  ShopProductViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

import RxCocoa
import RxSwift
import FloatingPanel

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Custom Method

    private func setDelegate() {
        rootView.productBottomSheet.delegate = self
        rootView.imageCollectionView.delegate = self
        rootView.imageCollectionView.dataSource = self
    }
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.cartButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let cartVC = ShopCartViewController()
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
        
        output.productData
            .asDriver(onErrorJustReturn: .init())
            .drive(with: self, onNext: { owner, data in
                owner.rootView.updateUI(data)
                owner.rootView.productBottomSheet.dataBind(data)
            })
            .disposed(by: disposeBag)
        
        
        output.showToast
            .asDriver(onErrorJustReturn: .unknown)
            .drive(with: self, onNext: { owner, toast in
                owner.showToast(toast.message, type: toast.type)
            })
            .disposed(by: disposeBag)
        
        output.pushToOrderVC
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, orderProducts in
                let orderVC = OrderViewController(orderProducts)
                owner.navigationController?.pushViewController(orderVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ShopProductViewController: ProductBottomSheetDelegate {
    
    func cartButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        cartButtonDidTap.accept(selectedProductOptions)
    }
    
    func orderButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        orderButtonDidTap.accept(selectedProductOptions)
    }
    
    
}

extension ShopProductViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.productData?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.reuseCellIdentifier,
                                                      for: indexPath) as! ProductImageCollectionViewCell
        cell.dataBind(image: viewModel.productData?.images[indexPath.row])
        return cell
    }
}

extension ShopProductViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Device.width
        let index = round(scrolledOffsetX / cellWidth)
        rootView.pageControl.currentPage = Int(index)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left,
                                              y: scrollView.contentInset.top)
    }
}
