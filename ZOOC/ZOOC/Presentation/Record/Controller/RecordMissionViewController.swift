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
    
    var petImage: UIImage?
    private var missionData = RecordMissionModel()
    private let placeHolderText: String = "오늘 어떤 일이 있었는지 공유해보세요"
    private var missionList: [RecordMissionListModel] = []
    
    var tappedCellIndex: Int?
    var galleryImageIsRegistered: Bool = false
    var contentTextViewIsRegistered: Bool = false
    
    //MARK: - UI Components
    
    private let rootView = RecordMissionView()
    
    //MARK: - Life Cycle
    
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
        guard let missionCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordMissionCollectionViewCell.cellIdentifier, for: indexPath) as? RecordMissionCollectionViewCell else { return UICollectionViewCell() }
        missionCell.dataBind(model: missionList[indexPath.item], index: indexPath)
        missionCell.delegate = self
        missionCell.contentTextView.delegate = self
        
        return missionCell
    }
}

extension RecordMissionViewController: RecordMissionCollectionViewCellDelegate {
    
    func sendTapEvent(index: IndexPath) {
        print("셀이 누른 이벤트가 뷰컨트롤러에 전달되었슴다~")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        tappedCellIndex = index.row
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
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //missionList[tappedCellIndex ?? 0].image = image
            rootView.missionCollectionView.reloadData()
            print(image)
            //if missionList[tappedCellIndex ?? 0].image == nil {
            print("이미지를 선택해주세요")
        } else {
            galleryImageIsRegistered = true
            updateUIViewController(galleryImageIsRegistered: galleryImageIsRegistered, contentTextViewIsRegistered: contentTextViewIsRegistered)
        }
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
            print("contentView 입력해줘..")
        } else {
            missionData.content = textView.text
            contentTextViewIsRegistered = true
            updateUIViewController(galleryImageIsRegistered: galleryImageIsRegistered, contentTextViewIsRegistered: true)
        }
    }
}

//MARK: - ScrollViewDelegate

extension RecordMissionViewController {
    func pushToRecordViewController() {
        let recordViewController = RecordViewController()
        navigationController?.pushViewController(recordViewController, animated: true)
        print(#function)
    }
    
    func pushToRecordAlertViewController() {
        let recordAlertViewController = ZoocAlertViewController()
        recordAlertViewController.modalPresentationStyle = .overFullScreen
        self.present(recordAlertViewController, animated: false, completion: nil)
    }
    
    func pushToRecordRegisterViewController() {
        let recordRegisterViewController = RecordRegisterViewController()
        
        recordRegisterViewController.dataBind(data: missionData)
        navigationController?.pushViewController(recordRegisterViewController, animated: true)
        print(#function)
        
    }
    
    private func updateUIViewController(galleryImageIsRegistered: Bool, contentTextViewIsRegistered: Bool) {
        if galleryImageIsRegistered == true && contentTextViewIsRegistered == true {
            rootView.nextButton.backgroundColor = .zoocGradientGreen
            rootView.nextButton.isEnabled = true
        } else {
            rootView.nextButton.backgroundColor = .zoocGray1
            rootView.nextButton.isEnabled = false
        }
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
            self.rootView.missionCollectionView.reloadData()
        }
    }
}

//HomeAPI.shared.getTotalPet(familyID: User.shared.familyID) { result in
//
//    guard let result = self.validateResult(result) as? [HomePetResult] else { return }
//
//    self.petData = result
//    guard let id = self.petData.first?.id else { return }
//    self.selectPetCollectionView(petID: id)
//
//
//}

