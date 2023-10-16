//
//  ShopChoosePetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/11.
//

import UIKit

import RxSwift
import RxCocoa

final class ShopChoosePetViewController: BaseViewController{
    
    // MARK: - Properties
    
    let viewModel: ShopChoosePetViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = ShopChoosePetView()
    private let layout = UICollectionViewFlowLayout()
    
    //MARK: - Life Cycle
    
    init(viewModel: ShopChoosePetViewModel) {
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
        
        configureCollectionViewLayout()
        bindUI()
        bindViewModel()
        
    }
    
    //MARK: - Custom Method
    
    private func bindViewModel() {
        let input = ShopChoosePetViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            petCellTapEvent: self.rootView.petCollectionView.rx.itemSelected.asObservable(),
            registerButtonDidTapEvent: self.rootView.registerButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: disposeBag)
    
        output.petList
            .asDriver(onErrorJustReturn: [])
            .drive(self.rootView.petCollectionView.rx.items) { collectionView, index, data in
                switch output.petList.value.count {
                case 4:
                    self.layout.itemSize = CGSize(
                        width: collectionView.frame.width / 2,
                        height: collectionView.frame.height / 2
                    )
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GenAIChooseFourPetCollectionViewCell.cellIdentifier,
                        for: IndexPath(item: index, section: 0)) as? GenAIChooseFourPetCollectionViewCell else { return UICollectionViewCell() }
                    cell.dataBind(data: data)
                    return cell
                default:
                    self.layout.itemSize = CGSize(
                        width: collectionView.frame.width,
                        height: collectionView.frame.height / CGFloat(output.petList.value.count)
                    )
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GenAIChoosePetCollectionViewCell.cellIdentifier,
                        for: IndexPath(item: index, section: 0)) as? GenAIChoosePetCollectionViewCell else { return UICollectionViewCell() }
                    cell.dataBind(data: data)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        output.canRegisterPet
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, canRegister in
                owner.updateRegisterButtonUI(canRegister)
            }).disposed(by: disposeBag)
        
        output.canPushNextView
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(with: self, onNext: { owner, _ in
                owner.pushToShopVC(with: owner.viewModel.getPetId())
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
//                guard let tabBarhandler = owner.tabBarhandler else { return }
//                tabBarhandler?()
            }).disposed(by: disposeBag)
    }
    
    private func configureCollectionViewLayout() {
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        self.rootView.petCollectionView.collectionViewLayout = layout
    }
}

extension ShopChoosePetViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}

extension ShopChoosePetViewController {
    func pushToShopVC(with petId: Int?) {
        let shopVC = ShopViewController(viewModel: ShopViewModel())
        shopVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(shopVC, animated: true)
    }
    
    func updateRegisterButtonUI(_ isSelected: Bool) {
        rootView.registerButton.isEnabled = isSelected
    }
}

