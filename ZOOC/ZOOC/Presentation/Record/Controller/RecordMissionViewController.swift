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
    private let screenInset: CGFloat = 30
    private let cardLineSpacing: CGFloat = 13
    private var missionList: [RecordMissionModel] = [
        RecordMissionModel(question: """
                                    반려동물이 사람처럼 느껴진
                                    순간은 언제인가요?
                                    """),
        RecordMissionModel(question: "반려동물의 가장 웃겼던 자세는 무엇인가요?"),
        RecordMissionModel(question: "자주 찾게 되는 반려동물 사진은 무엇인가요?"),
        RecordMissionModel(question: "반려동물이 내 옆에서 자는 모습을 찍어봐요."),
        RecordMissionModel(question: "반려동물의 제일 꼬질꼬질한 모습을 남겨봐요."),
        RecordMissionModel(question: "가족과 반려동물이 함께 찍은 사진을 기록해봐요"),
    ]
    var tappedCellIndex: Int = 100
    var galleryImageIsRegistered: Bool = false
    var contentTextViewIsRegistered: Bool = false
    
    //MARK: - UI Components
    
    private let topBarView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var xmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.xmark,
                        for: .normal)
        button.addTarget(self,
                         action: #selector(xButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private let buttonsContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dailyButton: UIButton = {
        let button = UIButton()
        button.setTitle("일상", for: .normal)
        button.titleLabel?.font = .zoocSubhead1
        button.setTitleColor(.zoocGray1, for: .normal)
        button.addTarget(self,
                         action: #selector(dailyButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var missionButton: UIButton = {
        let button = UIButton()
        button.setTitle("미션", for: .normal)
        button.titleLabel?.font = .zoocSubhead1
        button.setTitleColor(.zoocDarkGray1, for: .normal)
        return button
    }()
    
    private lazy var missionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    /*
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .zoocDarkGreen
        return view
    }()
    */
    
    public let missionIndicatorView = RecordMissionIndicatorView()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .zoocSubhead2
        button.setTitleColor(.zoocWhite1, for: .normal)
        button.backgroundColor = .zoocGray1
        button.isEnabled = false
        button.layer.cornerRadius = 27
        button.addTarget(self,
                         action: #selector(nextButtonDidTap),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setLayout()
    }
        
    //MARK: - Custom Method
    
    private func register() {
        missionCollectionView.register(RecordMissionCollectionViewCell.self, forCellWithReuseIdentifier: RecordMissionCollectionViewCell.identifier)
    }
    
    private func setLayout(){
        view.addSubviews(topBarView, missionCollectionView, missionIndicatorView, nextButton)
        
        topBarView.addSubviews(xmarkButton, buttonsContainerView)
        
        buttonsContainerView.addSubviews(dailyButton, missionButton)
        
        topBarView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(11)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(42)
        }
        
        xmarkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.width.equalTo(42)
            $0.height.equalTo(42)
        }
        
        buttonsContainerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(22)
            $0.width.equalTo(112)
            $0.height.equalTo(42)
        }
        
        dailyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(self.missionButton.snp.leading)
            $0.width.equalTo(56)
            $0.height.equalTo(42)
        }
        
        missionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(42)
        }
        
        missionCollectionView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(477)
        }
        
        missionIndicatorView.snp.makeConstraints {
            $0.top.equalTo(missionCollectionView.snp.bottom).offset(34)
            $0.width.equalTo(232)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(54)
        }
    }
    
    func pushToRecordViewController() {
        let recordViewController = RecordViewController()
        navigationController?.pushViewController(recordViewController, animated: true)
        print(#function)
    }
        
    func pushToRecordAlertViewController() {
        let recordAlertViewController = RecordAlertViewController()
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
            nextButton.backgroundColor = .zoocGradientGreen
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = .zoocGray1
            nextButton.isEnabled = false
        }
    }
    
    private func configIndicatorBarWidth(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5) {
            let allWidth = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
            let showingWidth = scrollView.bounds.width
            self.missionIndicatorView.widthRatio = showingWidth / allWidth
            self.missionIndicatorView.layoutIfNeeded()
        }
    }
    
    //MARK: - Action Method
    
    @objc private func xButtonDidTap(){
        pushToRecordAlertViewController()
    }
    
    @objc private func dailyButtonDidTap(){
        pushToRecordViewController()
    }

    
    @objc
    private func nextButtonDidTap(_ sender: Any) {
        pushToRecordRegisterViewController()
    }
}

extension RecordMissionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - (screenInset * 2)
        return CGSize(width: cardWidth, height: 477)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cardLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    /*
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.missionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
     */
    
    func scrollViewWillEndDragging (_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = screenWidth - (screenInset * 2)
        
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
        guard let missionCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordMissionCollectionViewCell.identifier, for: indexPath) as? RecordMissionCollectionViewCell else { return UICollectionViewCell() }
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
}

extension RecordMissionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            missionList[tappedCellIndex].image = image
            missionCollectionView.reloadData()
            print(image)
            if missionList[tappedCellIndex].image == nil {
                print("이미지를 선택해주세요")
            } else {
                galleryImageIsRegistered = true
                updateUIViewController(galleryImageIsRegistered: galleryImageIsRegistered, contentTextViewIsRegistered: contentTextViewIsRegistered)
            }
        }


    }
}

extension RecordMissionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = .black
        } else {
            
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == missionCollectionView {
            
            let scroll = scrollView.contentOffset.x + scrollView.contentInset.left
            let width = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
            let scrollRatio = scroll / width
            
            self.missionIndicatorView.leftOffsetRatio = scrollRatio
        }
    }
}