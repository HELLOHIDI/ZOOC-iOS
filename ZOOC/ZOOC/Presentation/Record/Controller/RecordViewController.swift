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
    
    
//    private var recordData = RecordModel()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    
    //MARK: - UI Components
    
    private let rootView = RecordView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gesture()
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
            selectRecordImageEvent: selectProfileImageSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    private func gesture(){
        rootView.contentTextView.delegate = self
    }

    
    @objc
    private func textViewDidTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc
    private func nextButtonDidTap(_ sender: Any) {
        view.endEditing(true)
        
    }
}

extension RecordViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == placeHoldText {
//            textView.text = nil
//            textView.textColor = .black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            textView.text = placeHoldText
//            textView.textColor = .zoocGray1
//        }
//    }
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
//        if let text = rootView.contentTextView.text{
//            recordData.content = text
//            let recordRegisterVC = RecordRegisterViewController(recordData: recordData)
//            navigationController?.pushViewController(recordRegisterVC, animated: true)
//        } else {
//            showToast("내용을 입력해주세요.", type: .bad)
//            return
//        }
    }
//
//    private func updateUI(){
//        if contentTextViewIsRegistered == false || recordData.image == nil {
//            rootView.nextButton.isEnabled = false
//        } else {
//            rootView.nextButton.isEnabled = true
//        }
//    }
}

//MARK: - ZoocAlertViewControllerDelegate

extension RecordViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}
