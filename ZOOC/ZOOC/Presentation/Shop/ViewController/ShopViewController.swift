//
//  ShopViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

final class ShopViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var petID: Int
    
    private var productsData: [ProductResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - UI Components
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.back, for: .normal)
        button.addTarget(self,
                         action: #selector(backButtonDidTap),
                         for: .touchUpInside)
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
        button.addTarget(self,
                         action: #selector(cartButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ShopProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier)
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    init(petID: Int) {
        self.petID = petID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setDelegate()
        style()
        hierarchy()
        layout()
        
        requestProductsAPI()
    }
    
    //MARK: - Custom Method
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    private func style() {
        
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

    private func requestProductsAPI() {
        ShopAPI.shared.getTotalProducts { result in
            guard let result = self.validateResult(result) as? [ProductResult] else { return }
            self.productsData = result
        }
    }
    
    
    //MARK: - Action Method
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func cartButtonDidTap() {
        let cartVC = ShopCartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource

extension ShopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        productsData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier,
                                                      for: indexPath) as! ShopProductCollectionViewCell
        
        if indexPath.row + 1 <= productsData.count {
            cell.dataBind(data: productsData[indexPath.row])
        } else {
            cell.setCommingSoon()
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ShopViewController {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row + 1 <= productsData.count {
            let productVC = ShopProductViewController(productID: productsData[indexPath.row].id, petID: petID)
            navigationController?.pushViewController(productVC, animated: true)
        } else {
            showToast("오픈 예정 제품이에요", type: .normal, bottomInset: 40)
        }
  
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width - 60 - 9
        width /= 2
        let height = (width * 200 / 153) + 50
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
    }
}
