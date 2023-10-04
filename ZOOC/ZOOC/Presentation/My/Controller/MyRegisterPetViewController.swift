//
//  MyRegisterPetViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/11.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class MyRegisterPetViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var index: Int?
    
    private let viewModel: MyRegisterPetViewModel
    
    private let deleteRegisterPetSubject = PublishSubject<Int>()
    private let addRegisterPetSubject = PublishSubject<Void>()
    private let deleteProfileImageSubject = PublishSubject<Int>()
    private let selectProfileImageSubject = PublishSubject<(UIImage, Int)>()
    private let changeNameSubject = PublishSubject<(String, Int)>()
    
    private let disposeBag = DisposeBag()
//    
//    private var dataSource:  RxCollectionViewSectionedReloadDataSource<SectionData<PetResult>>?
//    var sectionSubject = BehaviorRelay(value: [SectionData<PetResult>]())
//    
//    private var myPetMemberData: [PetResult] = [] {
//        didSet {
//            var updateSection: [SectionData<PetResult>] = []
//            updateSection.append(SectionData<PetResult>(items: myPetMemberData))
//            sectionSubject.accept(updateSection)
//        }
//    }
    
    //MARK: - UI Components
    
    private let rootView = MyRegisterPetView()
    
    private var galleryAlertController: GalleryAlertController {
        let galleryAlertController = GalleryAlertController()
        galleryAlertController.delegate = self
        return galleryAlertController
    }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
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
        
        register()
        bindUI()
        bindViewModel()
    }

    
    //MARK: - Custom Method
    
    
    private func register() {
        rootView.registerPetTableView.delegate = self
        rootView.registerPetTableView.dataSource = self
    }
    
    private func bindUI() {
        rootView.xmarkButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            if let presentingViewController = owner.presentingViewController {
                presentingViewController.dismiss(animated: true)
            } else if let navigationController = owner.navigationController {
                navigationController.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyRegisterPetViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            registerButtonDidTapEvent: self.rootView.registerPetButton.rx.tap.asObservable(),
            deleteRegisterPetEvent: deleteRegisterPetSubject.asObserver(),
            addRegisterPetEvent: addRegisterPetSubject.asObserver(),
            deleteRegisterPetImageEvent: deleteProfileImageSubject.asObserver(),
            selectRegisterPetImageEvent: selectProfileImageSubject.asObserver(),
            nameDidChangeEvent: changeNameSubject.asObserver()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.petMemberData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, _ in
                owner.rootView.registerPetTableView.reloadData()
            }).disposed(by: disposeBag)
        
        output.ableToRegisterPets
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, canRegister in
                guard let canRegister else { return }
                owner.rootView.registerPetButton.isEnabled = canRegister
            }).disposed(by: disposeBag)
        
        output.isRegistered
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, isRegisterd in
                guard let isRegisterd else { return }
                if isRegisterd {
                    if let presentingViewController = self.presentingViewController {
                        presentingViewController.dismiss(animated: true)
                    } else if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }
                else {
                    owner.showToast("반려동물 등록과정 중 문제가 발생했습니다", type: .bad)
                }
            }).disposed(by: disposeBag)
        
        output.registerPetData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, registerPetData in
                owner.rootView.registerPetTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    //MARK: - Action Method

    

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
        switch indexPath.section {
        case 0:
            let petData = viewModel.getPetMember()[indexPath.row]
            let hasPhoto = petData.photo == nil ? false : true
            let imageView = UIImageView()
            imageView.kfSetImage(url: petData.photo)
            let image = imageView.image
            let photo = hasPhoto ? image : nil
            let editPetProfileVC = MyEditPetProfileViewController(
                viewModel: MyEditPetProfileViewModel(
                    myEditPetProfileUseCase: DefaultMyEditPetProfileUseCase(
                        petProfileData: EditPetProfileRequest(
                            photo: hasPhoto,
                            nickName: petData.name,
                            file: photo
                        ),
                        id: petData.id,
                        repository: DefaultMyRepository()
                    )
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
            return viewModel.getPetMember().count
        case 1:
            return viewModel.getRegisterPetData().count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRegisteredPetTableViewCell.cellIdentifier, for: indexPath)
                    as? MyRegisteredPetTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.petProfileButton.tag = indexPath.row
            cell.dataBind(data: viewModel.getPetMember()[indexPath.row])
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRegisterPetTableViewCell.cellIdentifier, for: indexPath)
                    as? MyRegisterPetTableViewCell else { return UITableViewCell() }
            cell.dataBind(
                viewModel.getRegisterPetData()[indexPath.item],
                index: indexPath.item
            )
            cell.deletePetProfileButton.isHidden = viewModel.getDeleteButtonIsHidden()
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyRegisterPetTableFooterView.cellIdentifier) as? MyRegisterPetTableFooterView else { return UITableViewHeaderFooterView() }
            footer.delegate = self
            footer.addPetProfileButton.isHidden = viewModel.getAddButtonIsHidden()
            return footer
        default:
            return UIView()
        }
    }
}

extension MyRegisterPetViewController: MyRegisterPetTableViewCellDelegate {
    func deleteButtonTapped(tag: Int) {
        deleteRegisterPetSubject.onNext(tag)
    }
    
    func petProfileImageButtonDidTap(tag: Int) {
        self.index = tag
        self.present(self.galleryAlertController, animated: true)
    }
    
    func nameDidChanged(text: String, tag: Int) {
        changeNameSubject.onNext((text, tag))
    }
}

extension MyRegisterPetViewController: MyRegisterPetTableFooterViewDelegate {
    func addPetProfileButtonDidTap() {
        print(#function)
        addRegisterPetSubject.onNext(())
    }
}

extension MyRegisterPetViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        self.present(self.imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        guard let index = self.index else { return }
        deleteProfileImageSubject.onNext(index)
    }
}

extension MyRegisterPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let index = self.index else { return }
        selectProfileImageSubject.onNext((image,index))
        dismiss(animated: true)
    }
}
