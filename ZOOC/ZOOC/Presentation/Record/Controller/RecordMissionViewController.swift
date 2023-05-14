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
        pushToRecordAlertViewController()
    }
    
    @objc private func dailyButtonDidTap(){
        pushToRecordViewController()
    }
    
    @objc private func nextButtonDidTap(_ sender: Any) {
        pushToRecordRegisterViewController()
    }
}

extension RecordMissionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - (30 * 2)
        return CGSize(width: cardWidth, height: 477)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rootView.missionCollectionView {

            let scroll = scrollView.contentOffset.x + scrollView.contentInset.left
            let width = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
            let scrollRatio = scroll / width

            rootView.missionIndicatorView.leftOffsetRatio = scrollRatio
        }
    }
}

extension RecordMissionViewController: UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("삐약")
            return
        }
        self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].image = image
        self.rootView.missionCollectionView.reloadData()
    }
}

extension RecordMissionViewController: GalleryAlertControllerDelegate {
    func galleryButtonDidTap() {
        print(#function)
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
        print(#function)
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = self.recordMissionViewModel.placeHolderText
            textView.textColor = .zoocGray1
        } else {
            self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].content = textView.text
            self.rootView.missionCollectionView.reloadData()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        print(#function)
        if textView.text == "오늘 어떤 일이 있었는지 공유해보세요" || textView.text.isEmpty {
            presentBottomAlert("반려동물과 있었던 일을 작성해주세요~")
        } else {
            
        }
    }
}

//MARK: - ScrollViewDelegate

extension RecordMissionViewController {
    func pushToRecordViewController() {
        let recordViewController = RecordViewController()
        navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    func pushToRecordAlertViewController() {
        let recordAlertViewController = ZoocAlertViewController()
        recordAlertViewController.presentingVC = .record
        recordAlertViewController.modalPresentationStyle = .overFullScreen
        self.present(recordAlertViewController, animated: false, completion: nil)
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
    
    private func configIndicatorBarWidth(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5) {
            let allWidth = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
            let showingWidth = scrollView.bounds.width
            self.rootView.missionIndicatorView.widthRatio = showingWidth / allWidth
            self.rootView.missionIndicatorView.layoutIfNeeded()
        }
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


