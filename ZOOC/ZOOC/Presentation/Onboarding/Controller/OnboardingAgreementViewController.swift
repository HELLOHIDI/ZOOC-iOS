//
//  OnboardingAgreementViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit
import SafariServices

import RxSwift
import RxCocoa
import RxDataSources

final class OnboardingAgreementViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: OnboardingAgreementViewModel
    
    private let allAgreementCheckButtonDidTapEventSubject = PublishSubject<Void>()
    private let agreementCheckButtonDidTapEventSubject = PublishSubject<Int>()
    var sectionSubject = BehaviorRelay(value: [SectionData<OnboardingAgreementModel>]())
    private var dataSource:  RxCollectionViewSectionedReloadDataSource<SectionData<OnboardingAgreementModel>>?
    
    //MARK: - UI Components
    
    private lazy var rootView = OnboardingAgreementView.init(onboardingState: .makeFamily)
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingAgreementViewModel) {
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
        
        configureCollectionViewDataSource()
        configureCollectionView()
    }
    
    //MARK: - Custom Method
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionData<OnboardingAgreementModel>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OnboardingAgreementCollectionViewCell.cellIdentifier,
                    for: indexPath
                ) as! OnboardingAgreementCollectionViewCell
                cell.dataBind(tag: indexPath.row, data: item)
                cell.delegate = self
                return cell
            },configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
                let kind = UICollectionView.elementKindSectionHeader
                      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OnboardingAgreementCollectionHeaderView.reuseCellIdentifier, for: indexPath) as! OnboardingAgreementCollectionHeaderView
                header.allCheckedButton.isSelected = self.viewModel.getAllAgreed()
                header.delegate = self
                return header
            })
    }
    
    func configureCollectionView() {
        guard let dataSource else { return }
        sectionSubject
            .bind(to: rootView.agreementCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    
    private func bindUI() {
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.signUpButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.pushToWelcomeVC()
        }).disposed(by: disposeBag)

    }

    private func bindViewModel() {
        let input = OnboardingAgreementViewModel.Input(
            allAgreementCheckButtonDidTapEvent: allAgreementCheckButtonDidTapEventSubject.asObservable(),
            agreementCheckButtonDidTapEvent: agreementCheckButtonDidTapEventSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.agreementList.subscribe(with: self, onNext: { owner, agreementList in
            var updateSection: [SectionData<OnboardingAgreementModel>] = []
            updateSection.append(SectionData<OnboardingAgreementModel>(items: agreementList))
            owner.sectionSubject.accept(updateSection)
        }).disposed(by: disposeBag)
            
        output.ableToSignUp
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, canSignUp in
                owner.rootView.signUpButton.isEnabled = canSignUp
            }).disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate

extension OnboardingAgreementViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var url = ExternalURL.zoocDefaultURL
        switch indexPath.row {
        case 0: url = ExternalURL.termsOfUse
        case 1: url = ExternalURL.privacyPolicy
        case 3: url = ExternalURL.consentMarketing
        default: break
        }
        
        presentSafariViewController(url)
        return
    }
}

//MARK: - ChekedButtonTappedDelegate

extension OnboardingAgreementViewController: CheckedButtonTappedDelegate {
    func cellButtonTapped(index: Int) {
        agreementCheckButtonDidTapEventSubject.onNext(index)
    }
}

//MARK: - AllChekedButtonTappedDelegate

extension OnboardingAgreementViewController: AllChekedButtonTappedDelegate {
    func allCellButtonTapped() {
        allAgreementCheckButtonDidTapEventSubject.onNext(())
    }
}

extension OnboardingAgreementViewController {
    private func pushToWelcomeVC() {
        let welcomeVC = OnboardingWelcomeViewController()
        self.navigationController?.pushViewController(welcomeVC, animated: true)
    }
}
