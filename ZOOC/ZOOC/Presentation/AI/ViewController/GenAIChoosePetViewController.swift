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
    private let layout = UICollectionViewFlowLayout()
    
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
        
        self.rootView.petCollectionView.collectionViewLayout = layout
        bind()
        target()
        //        delegate()
    }
    
    //MARK: - Custom Method
    
    private func bind() {
        let input = GenAIChoosePetViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            petCellTapEvent: self.rootView.petCollectionView.rx.itemSelected.asObservable(),
            registerButtonDidTapEvent: self.rootView.registerButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
        output.petList
            .asDriver(onErrorJustReturn: [])
            .drive(self.rootView.petCollectionView.rx.items) { collectionView, index, data in
                self.layout.minimumLineSpacing = 0
                self.layout.minimumInteritemSpacing = 0
                self.layout.scrollDirection = .vertical
                switch output.petList.value.count {
                case 4:
                    self.layout.itemSize = CGSize(
                        width: collectionView.frame.width / 2,
                        height: collectionView.frame.height / 2
                    )
                    
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenAIChooseFourPetCollectionViewCell.cellIdentifier, for: IndexPath(item: index, section: 0)) as? GenAIChooseFourPetCollectionViewCell else { return UICollectionViewCell() }
                    cell.dataBind(data: data)
                    return cell
                default:
                    self.layout.itemSize = CGSize(
                        width: collectionView.frame.width,
                        height: collectionView.frame.height / CGFloat(output.petList.value.count)
                    )
                    
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenAIChoosePetCollectionViewCell.cellIdentifier, for: IndexPath(item: index, section: 0)) as? GenAIChoosePetCollectionViewCell else { return UICollectionViewCell() }
                    cell.dataBind(data: data)
                    return cell
                }
            }
            .disposed(by: self.disposeBag)
        
        output.canRegisterPet.subscribe(onNext: { [weak self] canRegister in
            self?.updateRegisterButtonUI(canRegister)
        }).disposed(by: self.disposeBag)
        
        output.canPushNextView.subscribe(onNext: { [weak self] _ in
            guard let petId = output.petId.value else { return }
            self?.pushToGenAIGuideVC(with: petId)
        }).disposed(by: self.disposeBag)
    }
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }

    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
}

extension GenAIChoosePetViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}

extension GenAIChoosePetViewController {
    func pushToGenAIGuideVC(with petId: Int) {
        let genAIGuideVC = GenAIGuideViewController(
            viewModel: DefaultGenAIGuideViewModel()
        )
        genAIGuideVC.hidesBottomBarWhenPushed = true
        genAIGuideVC.petId = petId
        navigationController?.pushViewController(genAIGuideVC, animated: true)
    }
    
    func updateRegisterButtonUI(_ isSelected: Bool) {
        rootView.registerButton.isEnabled = isSelected
    }
}
