//
//  OnboardingWelcomeViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingWelcomeViewController: UIViewController{
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingWelcomeView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.nextButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.pushToChooseFamilyRoleView()
        }).disposed(by: disposeBag)
    }
}

extension OnboardingWelcomeViewController {
    
    
    private func pushToChooseFamilyRoleView() {
        
    }
}
