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
    
    private var recordMissionViewModel: RecordMissionViewModel {
        didSet {
            self.recordMissionViewModel.updateNextButtonState(
                button: &self.rootView.nextButton.isEnabled,
                color: &self.rootView.nextButton.backgroundColor
            )
        }
    }
    private let placeHolderText: String = "오늘 어떤 일이 있었는지 공유해보세요"
    private var missionList: [RecordMissionListModel] = []
    private let galleryAlertController = GalleryAlertController()
    private lazy var imagePickerController = UIImagePickerController()
    
    //MARK: - UI Components
    
    private let rootView = RecordMissionView()
    
    //MARK: - Life Cycle
    
    init(recordMissionViewModel: RecordMissionViewModel, missionList: [RecordMissionListModel]) {
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
        
        requestMissionAPI()
    }
    
    //MARK: - Custom Method
    
    func target() {
        rootView.missionCollectionView.delegate = self
        rootView.missionCollectionView.dataSource = self
        self.galleryAlertController.delegate = self
        
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
        
        [cell.galleryImageView,
         cell.contentTextView].forEach { $0.tag = indexPath.row }
        
        cell.galleryImageView.image = self.recordMissionViewModel.missionData[indexPath.row].image
        cell.contentTextView.text = self.recordMissionViewModel.missionData[indexPath.row].content
        
        cell.contentTextView.delegate = self
        return cell
    }
}

extension RecordMissionViewController: RecordMissionCollectionViewCellDelegate {
    func sendTapEvent(tag: Int) {
        print(#function)
        checkAlbumPermission()
        guard let isPermission else { return }
        if isPermission {
            self.recordMissionViewModel.index = tag
            present(galleryAlertController,animated: true)
        } else {
            showAccessDenied()
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
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].image = image
//        self.recordMissionViewModel.updateNextButtonState(
//            button: &self.rootView.nextButton.isEnabled,
//            color: &self.rootView.nextButton.backgroundColor
//        )
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
        if textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolderText
            textView.textColor = .zoocGray1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "오늘 어떤 일이 있었는지 공유해보세요" || textView.text.isEmpty {
            presentBottomAlert("반려동물과 있었던 일을 작성해주세요~")
        } else {
            self.recordMissionViewModel.missionData[self.recordMissionViewModel.index].content = textView.text
            self.rootView.missionCollectionView.reloadData()
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
        recordAlertViewController.modalPresentationStyle = .overFullScreen
        self.present(recordAlertViewController, animated: false, completion: nil)
    }
    
    func pushToRecordRegisterViewController() {
        let recordRegisterViewController = RecordRegisterViewController()
        recordRegisterViewController.dataBind(data: self.recordMissionViewModel.missionData[self.recordMissionViewModel.index])
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
            guard let result = self.validateResult(result) as? [RecordMissionListModel] else { return }
            self.missionList = result
            
            for _ in 0..<result.count {
                self.recordMissionViewModel.missionData.append(RecordModel(image: Image.gallery))
            }
            
            self.rootView.missionCollectionView.reloadData()
        }
    }
}


