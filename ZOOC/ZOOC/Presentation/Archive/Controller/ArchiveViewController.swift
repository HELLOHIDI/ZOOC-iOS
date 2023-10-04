//
//  HomeDetailArchiveViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/05.
//

import UIKit

import SafariServices
import MessageUI

import SnapKit
import Then

final class ArchiveViewController : BaseViewController {
    
    //MARK: - Properties
    
    let rootView = ArchiveView()
    let guideVC = ArchiveGuideView()
    let emojiBottomSheetViewController = EmojiBottomSheetViewController()
    
    enum PageDirection: Int{
        case left
        case right
    }
    
    private var archiveModel: ArchiveModel
    
    private var archiveData: ArchiveResult? {
        didSet{
            rootView.updateArchiveUI(archiveData)
        }
    }
    
    private var commentsData: [CommentResult] = [] {
        didSet{
            rootView.updateCommentsUI(commentsData)
        }
    }
    
    
    
    //MARK: - Life Cycle
    
    init(_ archiveModel: ArchiveModel, scrollDown: Bool) {
        self.archiveModel = archiveModel
        rootView.scrollDown = scrollDown
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        gesture()
        
        requestDetailArchiveAPI(request: archiveModel)
        emojiBottomSheetViewController.modalPresentationStyle = .overFullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissKeyboardWhenTappedAround(cancelsTouchesInView: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification ,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaultsManager.isFirstAttemptArchive {
            guideVC.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifications()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.commentView.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Custom Method
    
    private func register() {
        rootView.commentCollectionView.delegate = self
        rootView.commentCollectionView.dataSource = self
        rootView.commentView.delegate = self
        emojiBottomSheetViewController.delegate = self
        
            
        rootView.commentCollectionView.register(ArchiveCommentCollectionViewCell.self,
                                       forCellWithReuseIdentifier: ArchiveCommentCollectionViewCell.cellIdentifier)
    }
    
    private func gesture() {
        rootView.backButton.addTarget(self,
                             action: #selector(backButtonDidTap),
                             for: .touchUpInside)

        rootView.etcButton.addTarget(self,
                            action: #selector(etcButtonDidTap),
                            for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(petImageViewDidTap))
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(handlePageSwipeGesture(_:)))
        swipeGestureLeft.direction = .left
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self,
                                                         action: #selector(handlePageSwipeGesture(_:)))
        swipeGestureRight.direction = .right
        
        rootView.petImageView.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeGestureLeft)
        view.addGestureRecognizer(swipeGestureRight)
        
    }
    
    private func updateNewPage(direction: PageDirection) {
        var message: String
        var id: Int?
        switch direction {
        case .left:
            message = "가장 최근 페이지입니다."
            id = archiveData?.leftID
        case .right:
            message = "마지막 페이지 입니다."
            id = archiveData?.rightID
        }
        
        guard let id else {
            showToast(message, type: .normal)
            return
        }
        
        archiveModel.recordID = id
        rootView.scrollDown = false
        rootView.scrollView.setContentOffset(CGPoint(x: 0,
                                                 y: 0),
                                         animated: true)
        requestDetailArchiveAPI(request: archiveModel)
    }
    private func deleteArchive() {
        guard let recordID = self.archiveData?.record.id else { return }
        let id = String(recordID)
        
        self.requestDeleteArchiveAPI(recordID: id)
    }
    
    private func presentZoocAlertVC() {
        let alertVC = ZoocAlertViewController(.deleteArchive)
        alertVC.delegate = self
        present(alertVC, animated: false)
    }
    
    //MARK: - API Method
    
    func requestDetailArchiveAPI(request: ArchiveModel) {
        HomeAPI.shared.getDetailPetArchive(recordID: request.recordID,
                                           petID: request.petID) { result in
            
            guard let result = self.validateResult(result) as? ArchiveResult else { return }
            
            self.archiveData = result
            self.commentsData = result.comments
        }
    }
    
    private func requestCommentsAPI(recordID: String, text: String) {
        HomeAPI.shared.postComment(recordID: recordID, comment: text) { result in
            guard let result = self.validateResult(result) as? [CommentResult] else { return }
            
            self.commentsData = result
            NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
            
        }
    }
    
    private func requestEmojiCommentAPI(recordID: String, emojiID: Int) {
        HomeAPI.shared.postEmojiComment(recordID: recordID, emojiID: emojiID) { result in
            guard let result = self.validateResult(result) as? [CommentResult] else { return }
            
            self.commentsData = result
            NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
        }
    }
    
    private func requestDeleteArchiveAPI(recordID: String) {
        ArchiveAPI.shared.deleteArchive(recordID: recordID) { result in
            self.validateResult(result)
            guard let tabVC = UIApplication.shared.rootViewController as? ZoocTabBarController else { return }
            tabVC.homeViewController.recordID = nil
            self.dismiss(animated: true)
        }
    }
    
    private func requestDeleteCommentAPI(commentID: String) {
        ArchiveAPI.shared.deleteComment(commentID: commentID) { result in
            self.validateResult(result)
            self.requestDetailArchiveAPI(request: self.archiveModel)
        }
    }
    
    //MARK: - Action Method
    
    @objc
    func backButtonDidTap() {
        guard let tabVC = UIApplication.shared.rootViewController as? ZoocTabBarController else { return }
        tabVC.homeViewController.recordID = nil
        dismiss(animated: true)
    }
    
    @objc
    private func etcButtonDidTap() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let reportAction =  UIAlertAction(title: "신고하기", style: .default) { action in
           
            self.sendMail(subject: "[ZOOC] 게시글 신고하기",
                          body: TextLiteral.mailRecordReportBody(recordID: self.archiveModel.recordID))
        }
        
        let destructiveAction = UIAlertAction(title: "삭제하기",
                                              style: .destructive) { action in
            self.presentZoocAlertVC()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        //메시지 창 컨트롤러에 버튼 액션을 추가
        guard let archiveData else { return }
        
        
        if archiveData.record.isMyRecord {
            alert.addAction(destructiveAction)
        } else {
            alert.addAction(reportAction)
        }
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc
    private func petImageViewDidTap() {
        let imageVC = ZoocImageViewController()
        imageVC.dataBind(image: rootView.petImageView.image)
        imageVC.modalPresentationStyle = .overFullScreen
        present(imageVC, animated: true)
    }
    
    @objc
    private func handlePageSwipeGesture(_ gesture: UIGestureRecognizer) {
        guard let gesture = gesture as? UISwipeGestureRecognizer else { return }
        switch gesture.direction {
        case .left:
            updateNewPage(direction: .right)
        case .right:
            updateNewPage(direction: .left)
        default:
            return
        }
        
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification){
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: duration){
            self.rootView.commentView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    @objc
    private func keyboardWillHide(notification: NSNotification){
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration){
            self.rootView.commentView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(19)
            }
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ArchiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return commentsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArchiveCommentCollectionViewCell.cellIdentifier,
                                                      for: indexPath) as! ArchiveCommentCollectionViewCell
        cell.delegate = self
        cell.dataBind(data: commentsData[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ArchiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 36
        
        if commentsData[indexPath.item].isEmoji{
            return CGSize(width: width, height: 126)
        } else {
            // 셀의 너비는 collectionView의 너비와 같습니다.
            let comment = commentsData[indexPath.item].content
            let commentLabel = UILabel(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: width,
                                                     height: CGFloat.greatestFiniteMagnitude))
            commentLabel.text = comment
            commentLabel.numberOfLines = 0
            let commentTextSize = commentLabel.sizeThatFits(commentLabel.frame.size)
            
            // 댓글 셀의 최소 높이
            let minHeight: CGFloat = 84
            
            // 댓글 텍스트의 높이와 최소 높이를 비교하여 큰 값을 선택하여 셀의 높이를 결정합니다.
            let cellHeight = max(minHeight, commentTextSize.height + 40) // 여백을 추가합니다.
            
            return CGSize(width: width, height: cellHeight)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 18, bottom: 30, right: 18)
    }
}

//MARK: - CommentViewDelegate

extension ArchiveViewController: ArchiveCommentViewDelegate {
   
    func uploadButtonDidTap(_ textField: UITextField, text: String) {
        guard let recordID = archiveData?.record.id else { return }
        textField.text = nil
        view.endEditing(true)
        requestCommentsAPI(recordID: String(recordID), text: text)
    }
    
    func emojiButtonDidTap() {
        dismissKeyboard()
        present(emojiBottomSheetViewController, animated: false)
    }
}

//MARK: - ArchiveCommentCellDelegate

extension ArchiveViewController: ArchiveCommentCellDelegate {
    func commentEtcButtonDidTap(isMyComment: Bool, id: Int) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let reportAction =  UIAlertAction(title: "신고하기", style: .default) { action in
           
            self.sendMail(subject: "[ZOOC] 댓글 신고하기", body: TextLiteral.mailCommentReportBody(commentID: id))
        }
        
        let destructiveAction = UIAlertAction(title: "삭제하기",
                                              style: .destructive) { action in
            let id = String(id)
            self.requestDeleteCommentAPI(commentID: id)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        //메시지 창 컨트롤러에 버튼 액션을 추가
        alert.addAction(reportAction)
        
        if isMyComment {
            alert.addAction(destructiveAction)
        }
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
   
}

//MARK: - EmojiBottomSheetDelegate

extension ArchiveViewController: EmojiBottomSheetDelegate{
    func emojiDidSelected(emojiID: Int) {
        guard let recordID = archiveData?.record.id else { return }
        requestEmojiCommentAPI(recordID: String(recordID), emojiID: emojiID)
    }
    
}

//MARK: - 구역

extension ArchiveViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        deleteArchive()
    }
    
}

extension ArchiveViewController: MFMailComposeViewControllerDelegate {
    private func sendMail(subject: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
            
                
                composeViewController.setToRecipients(["thekimhyo@gmail.com"])
                composeViewController.setSubject(subject)
                composeViewController.setMessageBody(body, isHTML: false)
                
                self.present(composeViewController, animated: true, completion: nil)
            } else {
                print("메일 보내기 실패")
                let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패",
                                                           message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
                                                           preferredStyle: .alert)
                let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기",
                                                     style: .default) { _ in
                    // 앱스토어로 이동하기(Mail)
                    let url = "https://apps.apple.com/kr/app/mail/id1108187098"
                    self.presentSafariViewController(url)
                }
                let cancleAction = UIAlertAction(title: "취소",
                                                 style: .destructive,
                                                 handler: nil)
                
                sendMailErrorAlert.addAction(goAppStoreAction)
                sendMailErrorAlert.addAction(cancleAction)
                self.present(sendMailErrorAlert,
                             animated: true,
                             completion: nil)
            }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            showToast("신고가 취소되었습니다.", type: .good)
        case .sent:
            showToast("신고가 접수되었습니다.", type: .good)
        case .saved:
            showToast("신고내용이 저장되었습니다.", type: .good)
        case .failed:
            showToast("신고하기에 오류가 발생했습니다.", type: .bad)
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }

}
