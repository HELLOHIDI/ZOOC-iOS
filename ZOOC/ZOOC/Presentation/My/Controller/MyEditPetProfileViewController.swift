//
//  MyEditPetProfileViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/06/22.
//

import UIKit

import SnapKit
import Then

final class MyEditPetProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var id: Int?
    private var myProfileData: PetResult?
    private var editPetProfileData = EditPetProfileRequest()
    
    //MARK: - UIComponents
    
    private lazy var rootView = MyEditProfileView()
    private let galleryAlertController = GalleryAlertController()
    private lazy var imagePickerController = UIImagePickerController()

    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        target()
        style()
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
    }
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        rootView.completeButton.addTarget(self, action: #selector(editCompleteButtonDidTap), for: .touchUpInside)
        
        rootView.profileImageButton.addTarget(self, action: #selector(profileImageButtonDidTap) , for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func style() {
        imagePickerController.do {
            $0.sourceType = .photoLibrary
        }
        
        rootView.numberOfNameCharactersLabel.text = "\(rootView.nameTextField.text!.count)/4"
    }

    func dataBind(data: PetResult?) {
        rootView.nameTextField.text = data?.name
        self.id = data?.id
        editPetProfileData.nickName = data?.name ?? ""
        
        if let photoURL = data?.photo{
            rootView.profileImageButton.kfSetButtonImage(url: photoURL)
        } else {
            rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        }
    }
    
    private func requestPatchUserProfileAPI() {
        guard let id = self.id else { return }
        MyAPI.shared.patchPetProfile(requset: editPetProfileData, id: id) { result in
            print(result)
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func profileImageButtonDidTap() {
        present(galleryAlertController,animated: true)
    }
    
    @objc func backButtonDidTap() {
        let myAlertViewController = ZoocAlertViewController()
        myAlertViewController.presentingVC = .editProfile
        myAlertViewController.modalPresentationStyle = .overFullScreen
        present(myAlertViewController, animated: false)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        guard let textField = notification.object as? UITextField else { return }
        guard let text = textField.text else { return }
        var textFieldState: BaseTextFieldState
        switch text.count {
        case 1...3:
            textFieldState = .isWritten
        case 4...:
            textFieldState = .isFull
            let fixedText = text.substring(from: 0, to:3)
            textField.text = fixedText + " "
            
            let when = DispatchTime.now() + 0.01
            DispatchQueue.main.asyncAfter(deadline: when) {
                textField.text = fixedText
            }
        default:
            textFieldState = .isEmpty
        }
        
        textFieldState.setTextFieldState(
            textField: nil,
            underLineView: rootView.underLineView,
            button: rootView.completeButton,
            label: rootView.numberOfNameCharactersLabel
        )
        setTextFieldText(textCount: text.count)
        
    }
    
    @objc func editCompleteButtonDidTap(){
        guard let nickName = rootView.nameTextField.text else { return }
        self.editPetProfileData.nickName = nickName
        requestPatchUserProfileAPI()
    }
}

extension MyEditPetProfileViewController {
    func setTextFieldText(textCount: Int) {
        rootView.numberOfNameCharactersLabel.text =  textCount < 4 ? "\(textCount)/4" : "4/4"
    }
    
    func setDefaultProfileImage() {
        rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
    }
    
    func setFamilyMemberProfileImage(photo: String) {
        rootView.profileImageButton.kfSetButtonImage(url: photo)
    }
    
    private func popToMyProfileView() {
        guard let beforeVC = self.navigationController?.previousViewController as? MyViewController else { return }
        beforeVC.requestMyPageAPI()
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - GalleryAlertControllerDelegate

extension MyEditPetProfileViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        rootView.profileImageButton.setImage(Image.defaultProfile, for: .normal)
        editPetProfileData.photo = false
    }
}

//MARK: - UIImagePickerControllerDelegate

extension MyEditPetProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        rootView.profileImageButton.setImage(image, for: .normal)
        rootView.completeButton.isEnabled = true
        self.editPetProfileData.file = image
        dismiss(animated: true)
    }
}


