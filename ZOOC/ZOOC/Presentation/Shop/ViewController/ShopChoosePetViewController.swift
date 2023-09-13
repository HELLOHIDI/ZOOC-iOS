//
//  ShopChoosePetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/11.
//

import UIKit

import SnapKit
import Then

final class ShopChoosePetViewController: BaseViewController {
    
    // MARK: - Properties

    let viewModel: GenAIChoosePetModel
    var petData: [PetResult] = [] {
        didSet {
            for pet in petData {
                viewModel.petList.value.append(pet.transform())
            }
        }
    }
    
    //MARK: - UI Components
    
    private let rootView = GenAIChoosePetView()
    
    //MARK: - Life Cycle
    
    init(viewModel: GenAIChoosePetModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        target()
        delegate()
    }
    
    //MARK: - Custom Method
    
    private func bind() {
        viewModel.petList.observe(on: self) { [weak self] _ in
            self?.rootView.petCollectionView.reloadData()
        }
        
        viewModel.ableToChoosePet.observe(on: self) { [weak self] isSelected in
            self?.updateRegisterButtonUI(isSelected)
        }
    }
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
    }
    
    private func delegate() {
        rootView.petCollectionView.delegate = self
        rootView.petCollectionView.dataSource = self
    }
    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerButtonDidTap(){
//        requestPetDatasetAPI()
    }
}

//MARK: - UICollectionViewDataSource

extension ShopChoosePetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.petList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(viewModel.petList.value.count <= 3) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenAIChoosePetCollectionViewCell.cellIdentifier, for: indexPath)
                    as? GenAIChoosePetCollectionViewCell else { return UICollectionViewCell() }
            
            cell.dataBind(data: viewModel.petList.value[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenAIChooseFourPetCollectionViewCell.cellIdentifier, for: indexPath)
                    as? GenAIChooseFourPetCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(data: viewModel.petList.value[indexPath.item], cellHeight: Int(collectionView.frame.height) / 2)
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension ShopChoosePetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.petButtonDidTapEvent(at: indexPath.item)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ShopChoosePetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.petList.value.count {
        case 1:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case 2:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2)
        case 3:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
        case 4:
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ShopChoosePetViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}

extension ShopChoosePetViewController {
    func pushToShopVC() {
        let shopVC = ShopViewController()
        shopVC.hidesBottomBarWhenPushed = true
        shopVC.petId = viewModel.petId.value
        navigationController?.pushViewController(shopVC, animated: true)
    }
    
    func updateRegisterButtonUI(_ isSelected: Bool) {
        rootView.registerButton.isEnabled = isSelected
    }
}
