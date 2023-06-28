//
//  RecordMissionViewController.swift
//  ZOOC
//
//  Created by 정윤선 on 2023/02/03.
//

import UIKit

import SnapKit
import Then

final class RecordMissionViewController : BaseViewController {
    
    //MARK: - Properties
    
    enum DestinationType {
        case home
        case daily
    }
    
    private var destinationType: DestinationType = .home
    
    private let placeHoldText: String = """
                                        ex) 2023년 2월 30일
                                        가족에게 어떤 순간이었는지 남겨주세요
                                        """
    private var recordMissionViewModel = RecordMissionViewModel()
    private var missionList: [RecordMissionResult] = []
    
    //MARK: - UI Components
    
    private let rootView = RecordMissionView()
    private let galleryAlertController = GalleryAlertController()
    private lazy var imagePickerController = UIImagePickerController()
    
    //MARK: - Life Cycle
    
    init(recordMissionViewModel: RecordMissionViewModel, missionList: [RecordMissionResult]) {
        self.recordMissionViewModel = recordMissionViewModel
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardNotifications()
        requestMissionAPI()
    }
        
    
    //MARK: - Custom Method
    
    func target() {
        rootView.missionCollectionView.delegate = self
        rootView.missionCollectionView.dataSource = self
        self.galleryAlertController.delegate = self
        self.imagePickerController.delegate = self
        
        rootView.xmarkButton.addTarget(self, action: #selector(xButtonDidTap), for: .touchUpInside)
        rootView.dailyButton.addTarget(self, action: #selector(dailyButtonDidTap), for: .touchUpInside)
        rootView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action Method
    
    @objc private func xButtonDidTap(){
        destinationType = .home
        presentAlertViewController()
    }
    
    @objc private func dailyButtonDidTap(){
        destinationType = .daily
        presentAlertViewController()
    }
    
    @objc private func nextButtonDidTap(_ sender: Any) {
        pushToRecordRegisterViewController()
    }
}

extension RecordMissionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - (30 * 2)
        return CGSize(width: cardWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }

    func scrollViewWillEndDragging (_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - (30 * 2)

        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = cardWidth + 13
        let index = round(scrolledOffsetX / cellWidth)
        self.recordMissionViewModel.index = Int(index)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}

extension RecordMissionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordMissionCollectionViewCell.cellIdentifier, for: indexPath) as? RecordMissionCollectionViewCell else { return UICollectionViewCell() }
        cell.dataBind(model: missionList[indexPath.item])
        cell.delegate = self
        
        [cell.galleryButton,
         cell.contentTextView].forEach { $0.tag = indexPath.row }
        
        cell.galleryButton.setImage(self.recordMissionViewModel.missionData[indexPath.row].image, for: .normal)
        cell.contentTextView.text = self.recordMissionViewModel.missionData[indexPath.row].content
        cell.contentTextView.textColor =
            self.recordMissionViewModel.missionData[indexPath.row].textColor
        
        cell.contentTextView.delegate = self
        
        self.recordMissionViewModel.updateNextButtonState(
            button: &self.rootView.nextButton.isEnabled,
            color: &self.rootView.nextButton.backgroundColor
        )
        return cell
    }
}

extension RecordMissionViewController: RecordMissionCollectionViewCellDelegate {
    func galleryButtonDidTap(tag: Int) {
        print(#function)
        checkAlbumPermission { hasPermission in
            if hasPermission {
                self.recordMissionViewModel.index = tag
                DispatchQueue.main.async {
                    self.present(self.galleryAlertController,animated: true)
                }
            } else {
                self.showAccessDenied()
            }
        }
    }
}

extension RecordMissionViewController: UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].image = image
            self.rootView.missionCollectionView.reloadData()
        }
        dismiss(animated: true)
    }
}

extension RecordMissionViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        present(imagePickerController, animated: true)
    }
    
    func deleteButtonDidTap() {
        self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].image = Image.gallery
        self.rootView.missionCollectionView.reloadData()
    }
}

extension RecordMissionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(#function)
        if textView.text == self.recordMissionViewModel.placeHolderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.recordMissionViewModel.updateContentTextView(
            index: self.recordMissionViewModel.index,
            contentText: textView.text
        )
        self.rootView.missionCollectionView.reloadData()
    }
}
//        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].content = self.recordMissionViewModel.placeHolderText
//            textView.textColor = .zoocGray1
//        } else {
//            self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].content = textView.text
//            textView.textColor = .zoocDarkGray1
//        }
        
//    }


//MARK: - ScrollViewDelegate

extension RecordMissionViewController {
    func pushToRecordViewController() {
        let recordViewController = RecordViewController()
        navigationController?.pushViewController(recordViewController, animated: false)
    }
    
    func presentAlertViewController() {
        let zoocAlertVC = ZoocAlertViewController()
        zoocAlertVC.delegate = self
        zoocAlertVC.alertType = .leavePage
        zoocAlertVC.modalPresentationStyle = .overFullScreen
        self.present(zoocAlertVC, animated: false, completion: nil)
    }
    
    func pushToRecordRegisterViewController() {
        let recordRegisterViewController = RecordRegisterViewController()
        recordRegisterViewController.dataBind(
            data: self.recordMissionViewModel.missionData[self.recordMissionViewModel.index],
            missionID: self.missionList[self.recordMissionViewModel.index].id
        )
        
        navigationController?.pushViewController(recordRegisterViewController, animated: true)
        print(#function)
    }
    
    private func requestMissionAPI() {
        RecordAPI.shared.getMission { result in
            guard let result = self.validateResult(result) as? [RecordMissionResult] else { return }
            self.missionList = result
            
            for _ in 0..<result.count {
                self.recordMissionViewModel.missionData.append(
                    RecordModel(
                        image: self.recordMissionViewModel.defaultImage,
                        content: self.recordMissionViewModel.placeHolderText
                    )
                )
            }
            self.rootView.missionCollectionView.reloadData()
        }
    }
}

//MARK: - ZoocAlertViewControllerDelegate

extension RecordMissionViewController: ZoocAlertViewControllerDelegate {
    
    func exitButtonDidTap() {
        switch destinationType {
            
        case .home:
            dismiss(animated: true)
        case .daily:
            pushToRecordViewController()
        }
        
    }
    
    
}


