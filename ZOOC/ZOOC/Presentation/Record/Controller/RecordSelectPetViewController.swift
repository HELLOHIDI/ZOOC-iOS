//
//  RecordRegisterViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import RxSwift
import RxCocoa

final class RecordSelectPetViewController : BaseViewController{
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: RecordSelectPetViewModel
    
    init(viewModel: RecordSelectPetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    private let rootView = RecordSelectPetView()
    private let layout = UICollectionViewFlowLayout()
    
    //MARK: - Life Cycle
    
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
    
    private func bindUI() {
        
        rootView.xmarkButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.presentAlertViewController()
        }).disposed(by: disposeBag)
        
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = RecordSelectPetViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            petCellTapEvent: self.rootView.petCollectionView.rx.itemSelected.asObservable(),
            recordButtonDidTapEvent: self.rootView.registerButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
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
                        withReuseIdentifier: RecordRegisterFourCollectionViewCell.cellIdentifier,
                        for: IndexPath(item: index, section: 0)) as? RecordRegisterFourCollectionViewCell else { return UICollectionViewCell() }
                    cell.dataBind(data)
                    return cell
                default:
                    self.layout.itemSize = CGSize(
                        width: collectionView.frame.width,
                        height: collectionView.frame.height / CGFloat(output.petList.value.count)
                    )
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RecordRegisterCollectionViewCell.cellIdentifier,
                        for: IndexPath(item: index, section: 0)) as? RecordRegisterCollectionViewCell else { return UICollectionViewCell() }
                    cell.dataBind(data)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        output.ableToRecord
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, canRecord in
                owner.rootView.registerButton.isEnabled = canRecord
            }).disposed(by: disposeBag)
        
        output.isRegistered
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, isRegistered in
                guard let isRegistered else { return }
                if isRegistered {
                    owner.pushToRecordCompleteViewController()
                } else {
                    owner.showToast("기록하기 중 문제가 발생했습니다.", type: .bad)
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureCollectionViewLayout() {
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        self.rootView.petCollectionView.collectionViewLayout = layout
    }
}

extension RecordSelectPetViewController {
    private func presentAlertViewController() {
        let zoocAlertVC = ZoocAlertViewController(.leavePage)
        zoocAlertVC.delegate = self
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
    
    private func pushToRecordCompleteViewController() {
        let recordCompleteVC = RecordCompleteViewController()
        self.navigationController?.pushViewController(recordCompleteVC, animated: true)
    }
}

extension RecordSelectPetViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}
