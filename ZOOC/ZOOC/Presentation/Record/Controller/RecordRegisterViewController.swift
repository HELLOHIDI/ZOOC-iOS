//
//  RecordRegisterViewController.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class RecordRegisterViewController : BaseViewController{
    
    // MARK: - Properties
    
    private var recordData: RecordModel
    private var petList: [RecordRegisterModel] = []
    private var selectedPetIDList: [Int] = []
    
    //MARK: - UI Components
    
    private let rootView = RecordRegisterView()
    
    //MARK: - Life Cycle
    
    init(recordData: RecordModel) {
        self.recordData = recordData
        
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
        
        target()
        
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RecordAPI.shared.getTotalPet { result in
            guard let result = self.validateResult(result) as? [PetResult] else { return }
            self.petList = []
            result.forEach { self.petList.append($0.transform()) }
            self.rootView.petCollectionView.reloadData()
        }
    }
    
    //MARK: - Custom Method
    
    private func target() {
        rootView.xmarkButton.addTarget(self, action: #selector(xButtonDidTap), for: .touchUpInside)
        rootView.backButton.addTarget(self, action: #selector(backButtonDidTap),for: .touchUpInside)
        rootView.registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        
        rootView.petCollectionView.delegate = self
        rootView.petCollectionView.dataSource = self
    }
    
    private func style() {
        
    }
    
    private func presentAlertViewController() {
        let zoocAlertVC = ZoocAlertViewController(.leavePage)
        zoocAlertVC.delegate = self
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
    
    //MARK: - Action Method
    
    @objc private func xButtonDidTap(){
        presentAlertViewController()
    }
    
    
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerButtonDidTap(){
        reqeustPostRecord()
    }
    
    private func activateButton(indexPathArray: [IndexPath]?) {
        if (indexPathArray?.count == 0) {
            rootView.registerButton.isEnabled = false
        } else {
            rootView.registerButton.isEnabled = true
        }
    }
    
    private func pushToRecordCompleteViewController() {
        let recordCompleteVC = RecordCompleteViewController(selectedPetID: selectedPetIDList)
        self.navigationController?.pushViewController(recordCompleteVC, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension RecordRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(petList.count <= 3) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecordRegisterCollectionViewCell.cellIdentifier, for: indexPath)
                    as? RecordRegisterCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(data: petList[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecordRegisterFourCollectionViewCell.cellIdentifier, for: indexPath)
                    as? RecordRegisterFourCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(data: petList[indexPath.item], cellHeight: Int(collectionView.frame.height) / 2)
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension RecordRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(petList.count <= 3) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecordRegisterCollectionViewCell else { return }
            petList[indexPath.row].isSelected = true
            cell.updateUI(isSelected: true)
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecordRegisterFourCollectionViewCell else { return }
            petList[indexPath.row].isSelected = true
            cell.updateUI(isSelected: true)
        }
        let indexPathArray = collectionView.indexPathsForSelectedItems
        activateButton(indexPathArray: indexPathArray)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(petList.count <= 3) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecordRegisterCollectionViewCell else { return }
            petList[indexPath.row].isSelected = false
            cell.updateUI(isSelected: false)
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecordRegisterFourCollectionViewCell else { return }
            petList[indexPath.row].isSelected = false
            cell.updateUI(isSelected: false)
        }
        let indexPathArray = collectionView.indexPathsForSelectedItems
        activateButton(indexPathArray: indexPathArray)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RecordRegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch petList.count {
        case 1:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case 2:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2)
        case 3:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
        case 4:
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension RecordRegisterViewController {
    func reqeustPostRecord() {
        petList.forEach {
            if $0.isSelected {
                selectedPetIDList.append($0.petID)
            }
        }
        
        RecordAPI.shared.postRecord(photo: recordData.image ?? UIImage(),
                                    content: recordData.content ?? "",
                                    pets: selectedPetIDList) { result in
            self.pushToRecordCompleteViewController()
        }
        
    }
}

extension RecordRegisterViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        dismiss(animated: true)
    }
}
