//
//  OnboardingParticipateViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingJoinFamilyViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: OnboardingJoinFamilyViewModel
    
    //MARK: - UI Components
    
    private let rootView = OnboardingJoinFamilyView.init(onboardingState: .processCodeReceived)
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingJoinFamilyViewModel) {
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
    }
    
    func bindViewModel() {
        let input = OnboardingJoinFamilyViewModel.Input(
            familyCodeTextFieldDidChange: rootView.familyCodeTextField.rx.text.orEmpty.asObservable(),
            nextButtonDidTapEvent: rootView.nextButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.enteredFamilyCode
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, code in
                owner.rootView.familyCodeTextField.text = code
            }).disposed(by: disposeBag)
        
        output.errMessage
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, err in
                guard let err else { return }
                owner.showToast(err, type: .bad)
            }).disposed(by: disposeBag)
        
        output.ableToCheckFamilyCode
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, canCheck in
                owner.rootView.nextButton.isEnabled = canCheck
            }).disposed(by: disposeBag)
        
        output.isJoinedFamily
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, isJoined in
                if isJoined { owner.pushToJoinCompletedViewController() }
            }).disposed(by: disposeBag)
    }
}

extension OnboardingJoinFamilyViewController {
    func pushToJoinCompletedViewController() {
        let joinCompletedVC = OnboardingJoinFamilyCompletedViewController()
        self.navigationController?.pushViewController(joinCompletedVC, animated: true)
    }
}

