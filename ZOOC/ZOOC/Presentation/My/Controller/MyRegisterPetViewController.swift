//
//  MyRegisterPetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/11.
//

import UIKit

import SnapKit
import Then

final class MyRegisterPetViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let myPetRegisterViewModel: MyPetRegisterViewModel
    
    private var myPetMemberData: [PetResult] = []
    
    //MARK: - UI Components
    
    private let rootView = MyRegisterPetView()
    private let galleryAlertController = GalleryAlertController()
    private lazy var imagePickerController = UIImagePickerController()
    
    //MARK: - Life Cycle
    
    init(myPetRegisterViewModel: MyPetRegisterViewModel) {
        self.myPetRegisterViewModel = myPetRegisterViewModel
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
        dismissKeyboardWhenTappedAround()
        
        register()
        target()
    }
    
    //MARK: - Custom Method
    
    private func register() {
        rootView.registerPetTableView.delegate = self
        rootView.registerPetTableView.dataSource = self
    }
    
    private func target() {
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
        
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.registerPetButton.addTarget(self, action: #selector(registerPetButtonDidTap), for: .touchUpInside)
    }
    
    func dataSend(myPetMemberData: [PetResult]) {
        self.myPetMemberData = myPetMemberData
        myPetRegisterViewModel.petCount = self.myPetMemberData.count
    }
    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerPetButtonDidTap() {
        rootView.registerPetButton.isEnabled = false
        rootView.registerPetButton.backgroundColor = .zoocGray1
        var names: [String] = []
        var photos: [Data] = []
        var photo: Data
        var isPhotos: [Bool] = []
        var isPhoto: Bool = true
        
        for pet in self.myPetRegisterViewModel.petList {
            guard let photo = pet.image.jpegData(compressionQuality: 1.0) else {
                photo = Data()
                isPhoto = false
                return
            }
            names.append(pet.name)
            photos.append(photo)
            isPhotos.append(isPhoto)
        }
        
        MyAPI.shared.registerPet(
            param: MyRegisterPetRequestDto(petNames: names, files: photos, isPetPhotos: isPhotos)
        ) { result in
            guard let result = self.validateResult(result) as? [MyRegisterPetResult] else {
                return
            }
            guard let tabVC = UIApplication.shared.rootViewController as? ZoocTabBarController else { return }
            tabVC.homeViewController.updateUI()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

//MARK: - UITableViewDelegate

extension MyRegisterPetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height: CGFloat = (section == 1) ? 64 : 0
        return height
    }
}

//MARK: - UITableViewDataSource

extension MyRegisterPetViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return myPetMemberData.count
        case 1:
            return myPetRegisterViewModel.petList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRegisteredPetTableViewCell.cellIdentifier, for: indexPath)
                    as? MyRegisteredPetTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.dataBind(data: myPetMemberData[indexPath.row])
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRegisterPetTableViewCell.cellIdentifier, for: indexPath)
                    as? MyRegisterPetTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            
            [cell.deletePetProfileButton,
             cell.petProfileImageButton,
             cell.petProfileNameTextField].forEach { $0.tag = indexPath.row }
            
            cell.petProfileNameTextField.text = self.myPetRegisterViewModel.petList[indexPath.row].name
            cell.petProfileImageButton.setImage(self.myPetRegisterViewModel.petList[indexPath.row].image, for: .normal)
            
            cell.myPetRegisterViewModel.deleteCellClosure = {
                self.myPetRegisterViewModel.deleteCell(index: self.myPetRegisterViewModel.index)
                self.rootView.registerPetTableView.reloadData()
            }
            
            self.myPetRegisterViewModel.checkCanRegister(
                button:&self.rootView.registerPetButton.isEnabled,
                color:&self.rootView.registerPetButton.backgroundColor
            )
            
            self.myPetRegisterViewModel.hideDeleteButton(button: &cell.deletePetProfileButton.isHidden)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyRegisterPetTableFooterView.cellIdentifier) as? MyRegisterPetTableFooterView else { return UITableViewHeaderFooterView() }
            
            cell.myPetRegisterViewModel.addCellClosure = { [weak self] in
                guard let self = self else { return }
                self.myPetRegisterViewModel.addCell()
                self.rootView.registerPetTableView.reloadData()
            }
            self.myPetRegisterViewModel.hideFooterView(button: &cell.addPetProfileButton.isHidden)
            return cell
        default:
            return UIView()
        }
    }
}

//MARK: - MyRegisterdPetTappedDelegate

extension MyRegisterPetViewController: MyRegisterdPetTappedDelegate {
    func petProfileButtonDidTap(tag: Int?) {
        guard let tag = tag else { return }
        print(tag)
    }
}

//MARK: - MyDeleteButtonTappedDelegate

extension MyRegisterPetViewController: MyDeleteButtonTappedDelegate {
    func petProfileImageButtonDidTap(tag: Int) {
        checkAlbumPermission { hasPermission in
            if hasPermission {
                self.myPetRegisterViewModel.index = tag
                DispatchQueue.main.async {
                    self.present(self.galleryAlertController,animated: true)
                }
            } else {
                self.showAccessDenied()
            }
        }
    }
    
    func deleteButtonTapped(tag: Int) {
        self.myPetRegisterViewModel.index = tag
    }
    
    func collectionViewCell(valueChangedIn textField: UITextField, delegatedFrom cell: UITableViewCell, tag: Int, image: UIImage) {
        if let _ = rootView.registerPetTableView.indexPath(for: cell), let text = textField.text {
            self.myPetRegisterViewModel.petList[tag] = MyPetRegisterModel(name: text, image: image)
        }
        self.myPetRegisterViewModel.checkCanRegister(
            button: &self.rootView.registerPetButton.isEnabled,
            color: &self.rootView.registerPetButton.backgroundColor)
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MyRegisterPetViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.myPetRegisterViewModel.petList[self.myPetRegisterViewModel.index].image = image
        self.rootView.registerPetTableView.reloadData()
        self.dismiss(animated: true)
        
    }
}

extension MyRegisterPetViewController {
    func registerPet() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyRegisterPetViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        print(#function)
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    func deleteButtonDidTap() {
        self.myPetRegisterViewModel.petList[self.myPetRegisterViewModel.index].image = Image.cameraCircle
        self.rootView.registerPetTableView.reloadData()
    }
}

