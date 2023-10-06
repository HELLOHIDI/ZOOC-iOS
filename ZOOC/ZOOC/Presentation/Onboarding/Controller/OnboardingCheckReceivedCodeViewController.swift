//
//  OnboardingCompleteProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingCheckReceivedCodeViewController: BaseViewController{
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: OnboardingCheckReceivedCodeViewModel
    
    //MARK: - UI Components
    
    private let rootView = OnboardingCheckReceivedCodeView.init(onboardingState: .checkReceivedCode)
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingCheckReceivedCodeViewModel) {
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
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.getCodeButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.pushToParticipateCompletedView()
        }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = OnboardingCheckReceivedCodeViewModel.Input(
            notGetCodeButtonDidTapEvent: self.rootView.notGetCodeButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.makeFamilySucceeded
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, makeFamilySucceeded in
                if makeFamilySucceeded {
                    owner.pushToInviteFamilyView()
                } else {
                    owner.showToast("가족을 생성하던 중 문제가 발생했습니다!", type: .bad)
                }
            }).disposed(by: disposeBag)
    }
}

private extension OnboardingCheckReceivedCodeViewController {
    func pushToParticipateCompletedView() {
        let onboardingParticipateVC = OnboardingJoinFamilyViewController(
            viewModel: OnboardingJoinFamilyViewModel(
                onboardingJoinFamilyUseCase: DefaultOnboardingJoinFamilyUseCase(
                    repository: DefaultOnboardingRepository()
                )
                )
            )
        self.navigationController?.pushViewController(onboardingParticipateVC, animated: true)
    }
    
    func pushToInviteFamilyView() {
        let onboardingInviteFamilyVC = OnboardingInviteFamilyViewController()
        self.navigationController?.pushViewController(onboardingInviteFamilyVC, animated: true)
    }
}
