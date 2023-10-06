////
////  ShopChoosePetViewController.swift
////  ZOOC
////
////  Created by 류희재 on 2023/09/11.
////
//
//import UIKit
//
//import SnapKit
//import Then
//
//final class ShopChoosePetViewController: BaseViewController {
//
//    // MARK: - Properties
//
//    let viewModel: GenAIChoosePetModel
//    var petData: [PetResult] = [] {
//        didSet {
//            for pet in petData {
//                viewModel.petList.value.append(pet.transform())
//            }
//        }
//    }
//
//    //MARK: - UI Components
//
//    private let rootView = ShopChoosePetView()
//
//    //MARK: - Life Cycle
//
//    init(viewModel: GenAIChoosePetModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func loadView() {
//        self.view = rootView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        bind()
//        target()
//        delegate()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        viewModel.viewWillAppearEvent()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        viewModel.deselectAllPet()
//    }
//
//    //MARK: - Custom Method
//
//    private func bind() {
//        viewModel.petList.observe(on: self) { [weak self] _ in
//            self?.rootView.petCollectionView.reloadData()
//        }
//
//        viewModel.ableToChoosePet.observe(on: self) { [weak self] isSelected in
//            self?.updateRegisterButtonUI(isSelected)
//        }
//
//        viewModel.isUploadedImage.observe(on: self) { [weak self] canPush in
//            guard let canPush = canPush else { return }
//            if canPush {
//                guard let petId = self?.viewModel.petId.value else { return }
//                self?.pushToShopVC(petID: petId)
//            } else {
//                self?.presentZoocAlertVC()
//            }
//        }
//
//        viewModel.isLoading.observe(on: self) { [weak self] isLoading in
//            guard let isLoading = isLoading else { return }
//            if isLoading {
//                self?.rootView.activityIndicatorView.startAnimating()
//            } else {
//                self?.rootView.activityIndicatorView.stopAnimating()
//            }
//        }
//    }
//
//    private func target() {
//        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
//        rootView.registerButton.addTarget(self, action: #selector(selectButtonDidTap), for: .touchUpInside)
//    }
//
//    private func delegate() {
//        rootView.petCollectionView.delegate = self
//        rootView.petCollectionView.dataSource = self
//    }
//
//    //MARK: - Action Method
//
//    @objc private func backButtonDidTap(){
//        navigationController?.popToRootViewController(animated: true)
//    }
//
//    @objc private func selectButtonDidTap(){
//        viewModel.selectButtonDidTap()
//    }
//}
//
////MARK: - UICollectionViewDataSource
//
//extension ShopChoosePetViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.petList.value.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if(viewModel.petList.value.count <= 3) {
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: GenAIChoosePetCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? GenAIChoosePetCollectionViewCell else { return UICollectionViewCell() }
//
//            cell.dataBind(data: viewModel.petList.value[indexPath.item])
//            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: GenAIChooseFourPetCollectionViewCell.cellIdentifier, for: indexPath)
//                    as? GenAIChooseFourPetCollectionViewCell else { return UICollectionViewCell() }
//            cell.dataBind(data: viewModel.petList.value[indexPath.item])
//            return cell
//        }
//    }
//}
//
////MARK: - UICollectionViewDelegate
//
//extension ShopChoosePetViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewModel.petButtonDidTapEvent(at: indexPath.item)
//    }
//}
//
////MARK: - UICollectionViewDelegateFlowLayout
//
//extension ShopChoosePetViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch viewModel.petList.value.count {
//        case 1:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
//        case 2:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2)
//        case 3:
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
//        case 4:
//            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
//        default:
//            return CGSize(width: 0, height: 0)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
//
//extension ShopChoosePetViewController: ZoocAlertViewControllerDelegate {
//    func keepButtonDidTap() {
//        pushToGenAIViewController()
//    }
//    func exitButtonDidTap() {
//        rootView.registerButton.isEnabled = true
//        dismiss(animated: true)
//    }
//}
//
//extension ShopChoosePetViewController {
//    func pushToShopVC(petID: Int) {
//        let shopVC = ShopViewController(petID: petID)
//        shopVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(shopVC, animated: true)
//    }
//
//    func updateRegisterButtonUI(_ isSelected: Bool) {
//        rootView.registerButton.isEnabled = isSelected
//    }
//
//    private func presentZoocAlertVC() {
//        if viewModel.hasDataset.value != nil {
//            let alertVC = ZoocUploadingImageAlertView()
//            present(alertVC, animated: false)
//        } else {
//            let alertVC = ZoocAlertViewController(.noDataset)
//            alertVC.delegate = self
//            present(alertVC, animated: false)
//        }
//    }
//
//    private func pushToGenAIViewController() {
//        if self.viewModel.petList.value.count > 0 {
//            let genAIGuideVC = GenAIGuideViewController(
//                viewModel: GenAIGuideViewModel(
//                    genAIGuideUseCase: DefaultGenAIGuideUseCase(
//                        petId: viewModel.petId.value
//                    )
//                )
//            )
//            navigationController?.pushViewController(genAIGuideVC, animated: true)
//        } else {
//            let genAIRegisterPetVC = GenAIRegisterPetViewController(
//                viewModel: GenAIRegisterPetViewModel(
//                    genAIRegisterPetUseCase: DefaultGenAIRegisterPetUseCase(
//                        repository: GenAIPetRepositoryImpl()
//                    )
//                )
//            )
//            navigationController?.pushViewController(genAIRegisterPetVC, animated: true)
//        }
//    }
//}
