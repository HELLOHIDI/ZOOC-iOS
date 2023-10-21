//
//  GenAISelectImageViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import RxSwift
import RxCocoa

final class GenAISelectImageViewController : BaseViewController {
    
    //MARK: - Properties
    
    let viewModel: GenAISelectImageViewModel
    private let reloadData = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    let rootView = GenAISelectImageView()
    
    //MARK: - Life Cycle
    
    init(viewModel: GenAISelectImageViewModel) {
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
        
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    func bindUI() {
        rootView.xmarkButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentAlertViewController()
            }).disposed(by: disposeBag)
        
        rootView.reSelectedImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(
                    name: Notification.Name("reselectImage"),
                    object: nil
                )
                owner.navigationController?.popViewController(animated: false)
            }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = GenAISelectImageViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            reloadData: reloadData.asObservable(),
            generateAIModelButtonDidTapEvent: self.rootView.generateAIModelButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.convertCompleted.subscribe(with: self, onNext: { owner, convertCompleted in
            guard let convertCompleted = convertCompleted else { return }
            if convertCompleted {
                owner.rootView.petImageCollectionView.reloadData()
                owner.reloadData.onNext(())
            }
        }).disposed(by: disposeBag)
        
        output.petImageDatasets.bind(to: self.rootView.petImageCollectionView.rx.items(
            cellIdentifier: GenAIPetImageCollectionViewCell.cellIdentifier,
            cellType: GenAIPetImageCollectionViewCell.self
        )) { index, _, cell in
            if output.petImageDatasets.value.count > 0 {
                cell.petImageView.image = output.petImageDatasets.value[index]
            }
        }.disposed(by: self.disposeBag)
        
        output.ableToShowImages
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, canShow in
                if canShow {
                    owner.rootView.activityIndicatorView.stopAnimating()
                    owner.rootView.petImageCollectionView.reloadData()
                } else {
                    owner.rootView.activityIndicatorView.startAnimating()
                }
            }).disposed(by: disposeBag)
        
        output.uploadRequestCompleted.subscribe(with: self, onNext: { owner, uploadCompleted in
            guard let uploadCompleted = uploadCompleted else { return }
            if uploadCompleted { owner.pushToGenAICompletedVC() }
            else { owner.showToast("AI 모델 생성 중 문제가 발생했습니다", type: .bad) }
        }).disposed(by: disposeBag)
        
        output.uploadCompleted.subscribe(with: self, onNext: { owner, convertCompleted in
            guard let convertCompleted else { return }
            
            if convertCompleted {
                owner.showToast("AI 모델 생성이 완료되었습니다", type: .good)
            } else {
                owner.showToast("AI 모델 생성 중 문제가 발생했습니다", type: .bad)
            }
        }).disposed(by: disposeBag)
    }
}

extension GenAISelectImageViewController {
    func presentAlertViewController() {
        let zoocAlertVC = ZoocAlertViewController(.leaveAIPage)
        zoocAlertVC.delegate = self
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
    
    func pushToGenAICompletedVC() {
        let genAICompletedVC = GenAICompletedViewController()
        self.navigationController?.pushViewController(genAICompletedVC, animated: true)
    }
}

extension GenAISelectImageViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}
