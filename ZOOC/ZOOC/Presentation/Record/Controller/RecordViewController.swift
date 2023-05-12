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
    
    private let topBarView = UIView()
    
    private lazy var xmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.xmark,
                        for: .normal)
        button.addTarget(self,
                         action: #selector(xButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let buttonsContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dailyButton: UIButton = {
        let button = UIButton()
        button.setTitle("일상", for: .normal)
        button.titleLabel?.font = .zoocSubhead1
        button.setTitleColor(.zoocDarkGray1, for: .normal)
        return button
    }()
    
    private lazy var missionButton: UIButton = {
        let button = UIButton()
        button.setTitle("미션", for: .normal)
        button.titleLabel?.font = .zoocSubhead1
        button.setTitleColor(.zoocGray1, for: .normal)
        button.addTarget(self,
                         action: #selector(missionButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.zoocSubGreen.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 14
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.backgroundColor = .white
        return view
    }()
    
    private let galleryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.gallery
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 18.0, bottom: 16.0, right: 18.0)
        textView.font = .zoocBody2
        textView.text = placeHoldText
        textView.textColor = .zoocGray1
        textView.backgroundColor = .zoocWhite2
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 12
        return textView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .zoocSubhead2
        button.setTitleColor(.zoocWhite1, for: .normal)
        button.backgroundColor = .zoocGray1
        button.isEnabled = false
        button.layer.cornerRadius = 27
        button.addTarget(self,
                         action: #selector(nextButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
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
        if textView.text == """
                                        ex) 2023년 2월 30일
                                        가족에게 어떤 순간이었는지 남겨주세요
                                        """ || textView.text.isEmpty {
            print("contentView 입력해줘..")
        } else {
            contentTextViewIsRegistered = true
            updateUI()
        }
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
        print(#function)
        
        checkAlbumPermission { hasPermission in
            if hasPermission {
                self.present(self.galleryAlertController,animated: true)
            } else {
                self.showAccessDenied()
            }
        }
    }
}
