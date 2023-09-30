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
    
    private var productData: ProductDetailResult? {
        didSet{
            updateUI()
            rootView.productBottomSheet.dataBind(productData)
        }
    }
    
    private var petID: Int
    private let disposeBag = DisposeBag()
    
    
    //MARK: - UI Components
    
    private let rootView = ShopProductView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    init(model: ShopProductModel) {
        self.petID = model.petID
        
        super.init(nibName: nil, bundle: nil)
        requestDetailProductAPI(id: model.productID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    private func updateUI() {
        rootView.imageCollectionView.reloadData()
        rootView.pageControl.numberOfPages = productData?.images.count ?? 0
        
        rootView.priceLabel.text = productData?.price.priceText
        rootView.nameLabel.text = productData?.name
        rootView.descriptionLabel.text = productData?.description
    }
    
    
    //MARK: - API Method
    
    private func requestDetailProductAPI(id: Int) {
        ShopAPI.shared.getProduct(productID: id) { result in
            guard let result = self.validateResult(result) as? ProductDetailResult else { return }
            self.productData = result
        }
    }
}

extension ShopProductViewController: ProductBottomSheetDelegate {
    func cartButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        guard let productData else { return }
        
        selectedProductOptions.forEach {
            let cartedProduct = CartedProduct(petID: petID,
                                              product: productData,
                                              selectedProduct: $0)
            DefaultRealmService.shared.setCartedProduct(cartedProduct)
        }
       
        showToast("장바구니에 상품이 담겼습니다.",
                  type: .good)
    }
    
    func orderButtonDidTap(_ selectedProductOptions: [SelectedProductOption]) {
        guard let productData else { return }
        var orderProducts: [OrderProduct] = []
        selectedProductOptions.forEach {
            orderProducts.append(OrderProduct(petID: petID,
                                              product: productData,
                                              selectedProductOption: $0))
        }
        let orderVC = OrderViewController(orderProducts)
        navigationController?.pushViewController(orderVC, animated: true)
    }
    
    
}

extension ShopProductViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.productData?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.reuseCellIdentifier,
                                                      for: indexPath) as! ProductImageCollectionViewCell
        cell.dataBind(image: productData?.images[indexPath.row])
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
