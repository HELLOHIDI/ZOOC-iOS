//
//  GenAIChoosePetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

final class GenAIChoosePetViewController: BaseViewController{
    
    // MARK: - Properties
    
    let viewModel: GenAIChoosePetViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = GenAIChoosePetView()
    
    //MARK: - Life Cycle
    
    init(viewModel: GenAIChoosePetViewModel) {
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
        let input = GenAIChoosePetViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            petCellTapEvent: self.rootView.petCollectionView.rx.itemSelected.asObservable(),
            registerButtonDidTapEvent: self.rootView.registerButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.petList.asDriver()
            .drive(rootView.petCollectionView.rx.items) { collectionView, index, data in
                let cell: UICollectionViewCell
                if self.viewModel.getPetListData().value.count == 4 {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenAIChooseFourPetCollectionViewCell.cellIdentifier, for: IndexPath(item: index, section: 0))
                    if let fourViewCell = cell as? GenAIChooseFourPetCollectionViewCell {
                        fourViewCell.dataBind(data: data, cellHeight: Int(collectionView.frame.height) / 2)
                    }
                } else {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenAIChoosePetCollectionViewCell.cellIdentifier, for: IndexPath(item: index, section: 0))
                    if let petCell = cell as? GenAIChoosePetCollectionViewCell {
                        petCell.dataBind(data: data)
                    }
                }
                return cell
            }.disposed(by: self.disposeBag)
        
        output.petList.asObservable().subscribe(onNext: { [weak self] _ in
            self?.rootView.petCollectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        output.canRegisterPet.asObservable().subscribe(onNext: { [weak self] canRegister in
            self?.updateRegisterButtonUI(canRegister)
        }).disposed(by: self.disposeBag)
    }
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
    }
    
    private func delegate() {
        rootView.petCollectionView.delegate = self
        //        rootView.petCollectionView.dataSource = self
    }
    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerButtonDidTap(){
        pushToGenAIGuideVC()
    }
}

//MARK: - UICollectionViewDataSource

//extension GenAIChoosePetViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.petList.value.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if(viewModel.petList.value.count <= 3) {
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: GenAIChoosePetCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? GenAIChoosePetCollectionViewCell else { return UICollectionViewCell() }
//
//            cell.dataBind(data: viewModel.petList.value[indexPath.item])
//            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: GenAIChooseFourPetCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? GenAIChooseFourPetCollectionViewCell else { return UICollectionViewCell() }
//            cell.dataBind(data: viewModel.petList.value[indexPath.item], cellHeight: Int(collectionView.frame.height) / 2)
//            return cell
//        }
//    }
//}

//MARK: - UICollectionViewDelegate
//
//extension GenAIChoosePetViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewModel.petButtonDidTapEvent(at: indexPath.item)
//    }
//}

//MARK: - UICollectionViewDelegateFlowLayout

extension GenAIChoosePetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.getPetListData().value.count {
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

extension GenAIChoosePetViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}

extension GenAIChoosePetViewController {
    func pushToGenAIGuideVC() {
        let genAIGuideVC = GenAIGuideViewController(
            viewModel: DefaultGenAIGuideViewModel()
        )
        genAIGuideVC.hidesBottomBarWhenPushed = true
        genAIGuideVC.petId = viewModel.getPetId().value
        navigationController?.pushViewController(genAIGuideVC, animated: true)
    }
    
    func updateRegisterButtonUI(_ isSelected: Bool) {
        rootView.registerButton.isEnabled = isSelected
    }
}
