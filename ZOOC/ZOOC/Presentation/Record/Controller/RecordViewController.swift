//
//  RecordViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import UIKit

import SnapKit
import Then

final class RecordViewController : BaseViewController{
    
    //MARK: - Properties
    
    var petImage: UIImage?
    private var recordData = RecordModel()
    private let placeHoldText: String = """
                                        ex) 2023년 2월 30일
                                        가족에게 어떤 순간이었는지 남겨주세요
                                        """
    var contentTextViewIsRegistered: Bool = false
    private let galleryAlertController = GalleryAlertController()
    private lazy var imagePickerController = UIImagePickerController()
    
    //MARK: - UI Components
    
    private let rootView = RecordView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gesture()
        target()
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
    
    private func target() {
        rootView.xmarkButton.addTarget(self,
                         action: #selector(xButtonDidTap),
                         for: .touchUpInside)
        rootView.missionButton.addTarget(self,
                         action: #selector(missionButtonDidTap),
                         for: .touchUpInside)
        rootView.nextButton.addTarget(self,
                         action: #selector(nextButtonDidTap),
                         for: .touchUpInside)
    }

    private func gesture(){
        self.imagePickerController.delegate = self
        rootView.contentTextView.delegate = self
        rootView.galleryImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self,action: #selector(galleryImageViewDidTap)))
    }
    
    //MARK: - Action Method
    
    @objc private func xButtonDidTap(){
        pushToRecordAlertViewController()
    }
    
    @objc private func missionButtonDidTap(){
        pushToRecordMissionViewController()
    }
    
    @objc private func galleryImageViewDidTap(){
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
    }
    
    @objc
    private func textViewDidTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc
    private func nextButtonDidTap(_ sender: Any) {
        pushToRecordRegisterViewController()
    }
}

extension RecordViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHoldText {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHoldText
            textView.textColor = .zoocGray1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == placeHoldText || textView.text.isEmpty {
            contentTextViewIsRegistered = false
        } else {
            contentTextViewIsRegistered = true
        }
        updateUI()
    }
}

extension RecordViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.recordData.image = image
            self.rootView.galleryImageView.image = image
            updateUI()
        }
        dismiss(animated: true)
    }
}

extension RecordViewController {
    func pushToRecordMissionViewController() {
        let recordMissionViewController = RecordMissionViewController(recordMissionViewModel: RecordMissionViewModel(), missionList: [])
        navigationController?.pushViewController(recordMissionViewController, animated: true)
    }
    
    func pushToRecordAlertViewController() {
        let recordAlertViewController = ZoocAlertViewController()
        recordAlertViewController.presentingVC = .record
        recordAlertViewController.modalPresentationStyle = .overFullScreen
        self.present(recordAlertViewController, animated: false, completion: nil)
    }
    
    func pushToRecordRegisterViewController() {
        let recordRegisterViewController = RecordRegisterViewController()
        
        if let text = rootView.contentTextView.text{
            recordData.content = text
        } else { return }
        
        recordRegisterViewController.dataBind(data: recordData, missionID: nil)
        navigationController?.pushViewController(recordRegisterViewController, animated: true)
        print(#function)
    }
    
    private func updateUI(){
        if contentTextViewIsRegistered == false || recordData.image == nil {
            rootView.nextButton.backgroundColor = .zoocGray1
            rootView.nextButton.isEnabled = false
        } else {
            rootView.nextButton.backgroundColor = .zoocGradientGreen
            rootView.nextButton.isEnabled = true
        }
    }
    
    private func ImageViewDidTap(tag: Int) {
        checkAlbumPermission { hasPermission in
            if hasPermission {
                DispatchQueue.main.async {
                    self.present(self.galleryAlertController,animated: true)
                }
            } else {
                self.showAccessDenied()
            }
        }
    }
}
