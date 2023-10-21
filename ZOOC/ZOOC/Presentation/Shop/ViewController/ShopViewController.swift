//
//  ShopViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import RxCocoa
import RxSwift
import FirebaseAnalytics

final class ShopViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: ShopViewModel
    private let disposeBag = DisposeBag()
    
    private let rootView = ShopView()
    private let refreshControl = UIRefreshControl()
    
    private let applyEventSubject = PublishSubject<Void>()
    
    
    //MARK: - Life Cycle
    
    init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindUI()
        bindViewModel()
        rootView.scrollView.refreshControl = refreshControl
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "Shop",
                                       AnalyticsParameterScreenClass: "ShopViewController"])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: - Custom Method
    
    func bindUI() {
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.cartButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let cartVC = ShopCartViewController(viewModel: ShopCartViewModel(service: DefaultRealmService()))
                cartVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(cartVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(with: self, onNext: { owner, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    owner.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        //        rootView.shopPetView.rx.tapGesture()
        //            .when(.recognized)
        //            .subscribe(with: self, onNext: { owner, _ in
        //                owner.rootView.showPetCollectionView = true
        //            })
        //            .disposed(by: disposeBag)
        
        //TODO: 주문내역 버튼을 눌렀을 때 아래 함수가 발동돼
        rootView.orderHistoryButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let webVC = ZoocWebViewController(url: "https://zooc-shopping.vercel.app/order", callBackHandlerName: "callBackHandler")
                webVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindViewModel() {
        let input = ShopViewModel.Input(
            viewDidLoadEvent: self.rx.viewDidLoad.asObservable(),
            //            petCellShouldSelectIndexPathEvent: rootView.petCollectionView.rx.itemSelected.asObservable().map { $0.row },
            //            petCellShouldSelectEvent: rootView.petCollectionView.rx.modelSelected(PetAiModel.self).asObservable(),
            refreshValueChangedEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            productCellDidSelectEvent:  self.rootView.shopCollectionView.rx.modelSelected(ProductResult.self).asObservable(),
            eventButtonDidTap: rootView.eventBannerImageView.rx.tapGesture().when(.recognized).map { _ in }.asObservable(),
            applyEventDidTap:
                applyEventSubject.asObservable()
        )
        
        let output = self.viewModel.transform(input: input, disposeBag: disposeBag)
        
        //        output.petAiData
        //            .asDriver(onErrorJustReturn: [])
        //            .drive(
        //                rootView.petCollectionView.rx.items(cellIdentifier: ShopPetCollectionViewCell.reuseCellIdentifier,
        //                                                    cellType: ShopPetCollectionViewCell.self)
        //            ) { row, data, cell in
        //                print("🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏")
        //                cell.dataBind(data)
        //            }
        //            .disposed(by: disposeBag)
        
        
        output.petAiData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, petData in
                guard !petData.isEmpty else { return }
                //owner.rootView.updateCollectionViewHeight(petData)
            })
            .disposed(by: disposeBag)
        
        output.petDidSelected
            .asDriver(onErrorJustReturn: (Int(), .init()))
            .drive(onNext: { [weak self] row, petAiData in
                self?.rootView.updateSelectedPetViewUI(petAiData)
                //self?.rootView.petCollectionView.selectCell(row: row)
                //self?.rootView.showPetCollectionView = false
            })
            .disposed(by: disposeBag)
        
        output.petDeselect
            .asDriver(onErrorJustReturn: Int())
            .drive(with: self, onNext: { owner, row in
                owner.rootView.updateNotSelectedPetUI()
                //                owner.rootView.petCollectionView.deselectCell(row: row)
                //owner.rootView.showPetCollectionView = false
            })
            .disposed(by: disposeBag)
        
        output.pushGenAIGuideVC
            .asDriver(onErrorJustReturn: Int())
            .drive(with: self, onNext: { owner, petID in
                let genAIGuideVC = GenAIGuideViewController(
                    viewModel: GenAIGuideViewModel(
                        genAIGuideUseCase: DefaultGenAIGuideUseCase(petId: petID)
                    )
                )
                genAIGuideVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(genAIGuideVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.productData
            .asDriver(onErrorJustReturn: [])
            .drive(
                rootView.shopCollectionView.rx.items(
                    cellIdentifier: ShopProductCollectionViewCell.reuseCellIdentifier,
                    cellType: ShopProductCollectionViewCell.self)
            ) { row, data, cell in
                cell.dataBind(data: data)
            }
            .disposed(by: disposeBag)
        
        output.pushShopProductVC
            .asDriver(onErrorJustReturn: ShopProductModel())
            .drive(with: self, onNext: { owner, model in
                let productVC = ShopProductViewController(viewModel: ShopProductViewModel(model: model,
                                                                                          service: DefaultRealmService()))
                productVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(productVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.eventImageShouldChanged
            .asDriver(onErrorJustReturn: UIImage())
            .drive(with: self, onNext: { owner, imageUrl in
                owner.rootView.eventBannerImageView.image = imageUrl
            })
            .disposed(by: disposeBag)
        
        output.presentEventView
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, _ in
                let alertVC = ZoocAlertViewController.init(.applyEvent)
                alertVC.delegate = owner
                owner.present(alertVC, animated: false)
            }).disposed(by: disposeBag)
        
        output.pushEventVC
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, imageUrl in
                let eventVC = ShopEventViewController()
                owner.navigationController?.pushViewController(eventVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.pushAIPetArchiveVC
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, imageUrl in
                let aiArchive = AiPetArchiveViewController()
                owner.navigationController?.pushViewController(aiArchive, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showShopToast
            .asDriver(onErrorJustReturn: .unknown)
            .drive(with: self, onNext: { owner, toast in
                owner.showToast(toast)
            })
            .disposed(by: disposeBag)
        
        output.showEventToast
            .asDriver(onErrorJustReturn: .unknown)
            .drive(with: self, onNext: { owner, toast in
                owner.showToast(toast)
            }).disposed(by: disposeBag)
    }
}

extension ShopViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        self.dismiss(animated: false)
    }
    
    func keepButtonDidTap() {
        applyEventSubject.onNext(())
        self.dismiss(animated: false)
    }
}
