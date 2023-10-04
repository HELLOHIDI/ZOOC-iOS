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

final class OnboardingAgreementViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private lazy var rootView = OnboardingAgreementView.init(onboardingState: .makeFamily)
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        target()
    }
    
    //MARK: - Custom Method
    
    private func register() {
        rootView.agreementTableView.delegate = self
//        rootView.agreementTableView.dataSource = self
    }
    
    private func target() {
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        rootView.signUpButton.addTarget(self,
                                                       action: #selector(signUpButtonDidTap),
                                                       for: .touchUpInside)
    }
    

    
    @objc private func signUpButtonDidTap() {
//        pushToWelcomeView()
    }
}

//MARK: - UITableViewDelegate

extension OnboardingAgreementViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
//}
//
////MARK: - UITableViewDataSource
//
//extension OnboardingAgreementViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return onboardingAgreementViewModel.agreementList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingAgreementTableViewCell.cellIdentifier, for: indexPath) as?
//                OnboardingAgreementTableViewCell else { return UITableViewCell() }
//        cell.delegate = self
//        cell.dataBind(tag: indexPath.row,
//                      text: onboardingAgreementViewModel.agreementList[indexPath.row].title)
//
//        if self.onboardingAgreementViewModel.agreementList[indexPath.row].isSelected {
//            cell.checkedButton.setImage(Image.checkBoxFill, for: .normal)
//        } else {
//            cell.checkedButton.setImage(Image.checkBox, for: .normal)
//        }
//
//        cell.onboardingAgreementViewModel.updateAgreementClosure = {
//            self.onboardingAgreementViewModel.updateAgreementState(
//                index: indexPath.row
//            )
//            self.rootView.agreementTableView.reloadData()
//        }
//        self.onboardingAgreementViewModel.updateNextButton(
//            button:&rootView.signUpButton.isEnabled)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: OnboardingAgreementTableHeaderView.cellIdentifier) as? OnboardingAgreementTableHeaderView else { return UITableViewHeaderFooterView() }
//        cell.delegate = self
//        if self.onboardingAgreementViewModel.allAgreement { cell.allCheckedButton.setImage(Image.checkBoxFill, for: .normal)
//            cell.allAgreementView.layer.borderColor = UIColor.zoocMainGreen.cgColor
//        } else {
//            cell.allCheckedButton.setImage(Image.checkBox, for: .normal)
//            cell.allAgreementView.layer.borderColor = UIColor.lightGray.cgColor
//        }
//
//        cell.onboardingAgreementViewModel.updateAllAgreementClosure = {
//            self.onboardingAgreementViewModel.updateAllAgreementState()
//            self.rootView.agreementTableView.reloadData()
//        }
//        self.onboardingAgreementViewModel.updateNextButton(
//            button:&rootView.signUpButton.isEnabled)
//        return cell
//    }
//}
//
////MARK: - ChekedButtonTappedDelegate
//
//extension OnboardingAgreementViewController: CheckedButtonTappedDelegate {
//    func cellButtonTapped(index: Int) {
//        onboardingAgreementViewModel.index = index
//        rootView.agreementTableView.reloadData()
//    }
//}
//
////MARK: - AllChekedButtonTappedDelegate
//
//extension OnboardingAgreementViewController: AllChekedButtonTappedDelegate {
//    func allCellButtonTapped() {
//        rootView.agreementTableView.reloadData()
//    }
//}
//
//extension OnboardingAgreementViewController {
//    private func pushToWelcomeView() {
//        let welcomeViewController = OnboardingWelcomeViewController()
//        self.navigationController?.pushViewController(welcomeViewController, animated: true)
//    }
//}
