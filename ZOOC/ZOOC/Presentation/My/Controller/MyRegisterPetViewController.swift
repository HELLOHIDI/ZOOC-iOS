//
//  MyRegisterPetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/11/07.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class MyRegisterPetViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyRegisterPetViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = MyRegisterPetView()
    
    //MARK: - Life Cycle
    
    init(viewModel: MyRegisterPetViewModel) {
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
    
    private func bindUI() {
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            if let presentingViewController = owner.presentingViewController {
                presentingViewController.dismiss(animated: true)
            } else if let navigationController = owner.navigationController {
                navigationController.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyRegisterPetViewModel.Input(
            registerButtonDidTapEvent: rootView.completeButton.rx.tap.asObservable(),
            nameDidChangeEvent: rootView.nameTextField.rx.controlEvent(.editingChanged).map { [weak self] in
                self?.rootView.nameTextField.text ?? "" }
                .asObservable(),
            breedDidChangeEvent:
                rootView.breedTextField.rx.controlEvent(.editingChanged).map { [weak self] in
                    self?.rootView.breedTextField.text ?? "" }
                .asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.ableToRegisterPet
            .asDriver()
            .drive(with: self, onNext: { owner, canRegister in
                let updateColor: UIColor = canRegister ? .zw_black : .zw_lightgray
                owner.rootView.completeButton.backgroundColor = updateColor
            }).disposed(by: disposeBag)
        
        output.petName
            .asDriver()
            .drive(with: self, onNext: { owner, name in
                owner.rootView.nameTextField.updateTextField(name)
            }).disposed(by: disposeBag)
        
        output.petBreed
            .asDriver()
            .drive(with: self, onNext: { owner, breed in
                owner.rootView.breedTextField.updateTextField(breed)
            }).disposed(by: disposeBag)
    }
}
