//
//  ShopViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit

final class ShopViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: ShopViewModel
    private let disposeBag = DisposeBag()

    //MARK: - UI Components
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.back, for: .normal)
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Image.logoCombination)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.cart, for: .normal)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 9
        var width = (Device.width - 60 - 9) / 2
        let height = (width * 200 / 153) + 50
        layout.itemSize = CGSize(width: width, height: height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        collectionView.register(ShopProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier)
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hierarchy()
        layout()
        
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    func bindUI() {
        backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        cartButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let cartVC = ShopCartViewController()
                owner.navigationController?.pushViewController(cartVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func bindViewModel() {
        let input = ShopViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            productCellDidSelectEvent: self.collectionView.rx.modelSelected(ProductResult.self).asObservable()
                
        )
        
        let output = self.viewModel.transform(input: input, disposeBag: disposeBag)
        
        
        output.productData
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.collectionView.rx.items(
                    cellIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier,
                    cellType: ShopProductCollectionViewCell.self)
            ) { row, data, cell in
                cell.dataBind(data: data)
            }
            .disposed(by: disposeBag)
            
        output.pushShopProductVC
            .asDriver(onErrorJustReturn: ShopProductModel())
            .drive(with: self, onNext: { owner, model in
                let productVC = ShopProductViewController(model: model)
                owner.navigationController?.pushViewController(productVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func hierarchy() {
        view.addSubviews(backButton,
                         logoImageView,
                         cartButton,
                         collectionView)
    }
    
    private func layout() {
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(11)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
            $0.height.equalTo(30)
        }
        
        cartButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(11)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(42)
        }
        
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(69)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
}

//MARK: - UICollectionViewDataSource
//
//extension ShopViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        productsData.count + 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier,
//                                                      for: indexPath) as! ShopProductCollectionViewCell
//
//        if indexPath.row + 1 <= productsData.count {
//            cell.dataBind(data: productsData[indexPath.row])
//        } else {
//            cell.setCommingSoon()
//        }
//        return cell
//    }
//}
//
////MARK: - UICollectionViewDelegate
//
//extension ShopViewController {
//    func collectionView(_ collectionView: UICollectionView,
//                        didSelectItemAt indexPath: IndexPath) {
//
////        if indexPath.row + 1 <= productsData.count {
////            let productVC = ShopProductViewController(productID: productsData[indexPath.row].id, petID: petID)
////            navigationController?.pushViewController(productVC, animated: true)
////        } else {
////            showToast("오픈 예정 제품이에요", type: .normal, bottomInset: 40)
////        }
//
//    }
//}
//
////MARK: - UICollectionViewDelegateFlowLayout
//
//extension ShopViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var width = collectionView.frame.width - 60 - 9
//        width /= 2
//        let height = (width * 200 / 153) + 50
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 30
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 9
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
//    }
//}
