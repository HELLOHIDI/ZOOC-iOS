//
//  RecordViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit

import RxSwift
import RxCocoa

final class RecordViewController : BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: RecordViewModel
    
    init(viewModel: RecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let selectProfileImageSubject = PublishSubject<UIImage>()
    private let updateContentTextViewSubject = PublishSubject<String>()
    
    //MARK: - UI Components
    
    private let rootView = RecordView()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        bindUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifications()
    }
    
    // MARK: - Custom Method
    
    private func bindUI() {
        rootView.xmarkButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.presentAlertViewController()
        }).disposed(by: disposeBag)
        
        rootView.nextButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.pushToRecordRegisterViewController()
        }).disposed(by: disposeBag)
        
        rootView.galleryImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.present(owner.imagePickerController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = RecordViewModel.Input(
            selectRecordImageEvent: selectProfileImageSubject.asObservable(),
            textViewDidTapEvent: updateContentTextViewSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.image
            .asDriver()
            .drive(with: self, onNext: { owner, image in
                guard let image else { return }
                owner.rootView.galleryImageView.image = image
            }).disposed(by: disposeBag)
        
        output.content
            .asDriver()
            .drive(with: self, onNext: { owner, content in
                guard let content else { return }
                owner.updateTextViewUI(content)
            }).disposed(by: disposeBag)
        
        output.ableToRecord
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, canRecord in
                guard let canRecord else { return }
                owner.rootView.nextButton.isEnabled = canRecord
            }).disposed(by: disposeBag)
    }
    
    private func delegate() {
        rootView.contentTextView.delegate = self
    }
}

extension RecordViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateContentTextViewSubject.onNext(textView.text)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateContentTextViewSubject.onNext(textView.text)
    }
}

extension RecordViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        selectProfileImageSubject.onNext(image)
        dismiss(animated: true)
    }
}


extension RecordViewController {
    func presentAlertViewController() {
        let zoocAlertVC = ZoocAlertViewController(.leavePage)
        zoocAlertVC.delegate = self
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
    
    func pushToRecordRegisterViewController() {
        let recordRegisterVC = RecordSelectPetViewController(
            viewModel: RecordSelectPetViewModel(
                recordSelectPetUseCase: DefaultRecordSelectPetUseCase(
                    photo: viewModel.getPhoto(),
                    content: viewModel.getContent(),
                    repository: DefaultRecordRepository()
                )
            )
        )
        navigationController?.pushViewController(recordRegisterVC, animated: true)
    }
    
    func updateTextViewUI(_ content: String) {
        rootView.contentTextView.text = content
        if content != TextLiteral.recordPlaceHolderText {
            rootView.contentTextView.textColor = .zoocGray3
        } else {
            rootView.contentTextView.textColor = .zoocGray1
        }
    }
}

//MARK: - ZoocAlertViewControllerDelegate

extension RecordViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}
