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
        
        delegate()
        register()
        target()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestPetResult()
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        galleryAlertController.delegate = self
        imagePickerController.delegate = self
    }
    
    private func register() {
        rootView.registerPetTableView.delegate = self
        rootView.registerPetTableView.dataSource = self
    }
    
    private func target() {
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        rootView.registerPetButton.addTarget(self, action: #selector(registerPetButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerPetButtonDidTap() {
        rootView.registerPetButton.isEnabled = false
        var names: [String] = []
        var photos: [Data] = []
        var isPhotos: [Bool] = []
        var isPhoto: Bool = true
        
        for pet in self.myPetRegisterViewModel.petList {
            isPhoto = pet.image != Image.cameraCircle
            guard let photo = pet.image.jpegData(compressionQuality: 1.0) else {
                isPhoto = false
                return
            }
            names.append(pet.name)
            photos.append(photo)
            isPhotos.append(isPhoto)
        }
        
        MyAPI.shared.registerPet(
            param: MyRegisterPetRequest(petNames: names, files: photos, isPetPhotos: isPhotos)
        ) { result in
            self.validateResult(result)
            NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
            NotificationCenter.default.post(name: .myPageUpdate, object: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        switch indexPath.section {
        case 0:
            let petData = myPetMemberData[indexPath.row]
            let hasPhoto = petData.photo == nil ? false : true
            let imageView = UIImageView()
            imageView.kfSetImage(url: petData.photo)
            let image = imageView.image
            let photo = hasPhoto ? image : nil
            let editPetProfileVC = MyEditPetProfileViewController(
                viewModel: MyEditPetProfileViewModel(
                    id: petData.id,
                    editPetProfileRequest: EditPetProfileRequest(
                        photo: hasPhoto,
                        nickName: petData.name,
                        file: photo
                    ),
                    repository: MyEditPetProfileRepositoryImpl()
                )
            )
            navigationController?.pushViewController(editPetProfileVC, animated: true)
        default:
            return
        }
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
            cell.petProfileButton.tag = indexPath.row
            cell.dataBind(data: myPetMemberData[indexPath.row])
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
                button:&self.rootView.registerPetButton.isEnabled
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
            button: &self.rootView.registerPetButton.isEnabled)
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
    func requestPetResult() {
        MyAPI.shared.getMyPageData() { result in
            guard let result = self.validateResult(result) as? MyResult else { return }
            self.myPetMemberData = result.pet
            self.rootView.registerPetTableView.reloadData()
        }
    }
}

extension MyRegisterPetViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    func deleteButtonDidTap() {
        self.myPetRegisterViewModel.petList[self.myPetRegisterViewModel.index].image = Image.cameraCircle
        self.rootView.registerPetTableView.reloadData()
    }
}

