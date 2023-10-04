//
//  HomeDetailArchiveViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/05.
//

import UIKit
import SafariServices
import MessageUI

import RxCocoa
import RxSwift


enum HorizontalSwipe {
    //default value: left
    case left
    case right
}

final class ArchiveViewController : BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: ArchiveViewModel
    private let rootView = ArchiveView()
    private let guideVC = ArchiveGuideView()
    private let emojiBottomSheetViewController = EmojiBottomSheetViewController()
    private let disposeBag = DisposeBag()
    
    private let uploadCommentButtonDidTapEvent = PublishRelay<String>()
    private let emojiDidSelectEvent = PublishRelay<Int>()
    private let commentReportButtonDidTapEvent = PublishRelay<Int>()
    private let commentDeleteButtonDidTapEvent = PublishRelay<Int>()
    private let deleteArchiveEvent = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(viewModel: ArchiveViewModel, scrollDown: Bool) {
        self.viewModel = viewModel
        rootView.scrollDown = scrollDown
        super.init(nibName: nil, bundle: nil)
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
    
    func bindUI() {
        
        rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                guard let tabVC = UIApplication.shared.rootViewController as? ZoocTabBarController else { return }
                tabVC.homeViewController.recordID = nil
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.etcButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.etcButtonDidTap()
            })
            .disposed(by: disposeBag)
        
        rootView.petImageView.rx.tapGesture().asObservable()
            .subscribe(with: self, onNext: { owner, _ in
                owner.petImageViewDidTap()
            })
            .disposed(by: disposeBag)
        
        rootView.rx.swipeGesture(.left).asObservable()
            .subscribe(with: self, onNext: { owner, swipe in
                print("왼쪽~~")
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindViewModel() {
        let input = ArchiveViewModel.Input(
            viewDidLoadEvent: rx.viewDidLoad.asObservable(),
            deleteArchiveButtonDidTap: rootView.etcButton.rx.tap.asObservable(),
            swipeGestureEvent: rootView.rx.swipeGesture(.left, .right).asObservable().map { $0.direction.transform()},
            commentUploadButtonDidTapEvent: uploadCommentButtonDidTapEvent.asObservable(),
            emojiDidSelectEvent: emojiDidSelectEvent.asObservable(),
            commentReportButtonDidTapEvent: commentReportButtonDidTapEvent.asObservable(),
            commentDeleteButtonDidTapEvent: commentDeleteButtonDidTapEvent.asObservable()
        )
        
        let output = viewModel.tranform(input: input, disposeBag: disposeBag)
        
        output.dismissToHomeVC
            .asDriver(onErrorJustReturn: ())
            .drive(with: self, onNext: { owner, _ in
                guard let tabVC = UIApplication.shared.rootViewController as? ZoocTabBarController else { return }
                tabVC.homeViewController.recordID = nil
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.archiveData
            .asDriver(onErrorJustReturn: .init())
            .drive(with: self, onNext: { owner, data in
                owner.rootView.updateArchiveUI(data)
            })
            .disposed(by: disposeBag)
        
        output.commentData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, data in
                owner.rootView.updateCommentsUI(data)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func updateNewPage(_ direction: UISwipeGestureRecognizer.Direction) {
        var message: String
        var id: Int?
        switch direction {
        case .left:
            message = "가장 최근 페이지입니다."
            id = archiveData?.leftID
        case .right:
            message = "마지막 페이지 입니다."
            id = archiveData?.rightID
        default:
            return
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
    
    private func presentZoocAlertVC() {
        let alertVC = ZoocAlertViewController(.deleteArchive)
        alertVC.delegate = self
        present(alertVC, animated: false)
    }
    
    
    
   private func etcButtonDidTap() {
       let alert = UIAlertController(title: nil,
                                     message: nil,
                                     preferredStyle: .actionSheet)
        
       let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
       
       if archiveData.record.isMyRecord {
           let destructiveAction = UIAlertAction(title: "삭제하기",
                                                  style: .destructive) { _ in
                self.presentZoocAlertVC()
            }
            alert.addAction(destructiveAction)
        } else {
            let reportAction =  UIAlertAction(title: "신고하기", style: .default) { _ in
               
                self.sendMail(subject: "[ZOOC] 게시글 신고하기",
                              body: TextLiteral.mailRecordReportBody(recordID: self.archiveModel.recordID))
            }
            alert.addAction(reportAction)
        }
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func petImageViewDidTap() {
        let imageVC = ZoocImageViewController()
        imageVC.dataBind(image: rootView.petImageView.image)
        imageVC.modalPresentationStyle = .overFullScreen
        present(imageVC, animated: true)
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
        guard let archiveData else { return }
        view.endEditing(true)
        uploadCommentButtonDidTapEvent.accept(text)\
    }
    
    func emojiButtonDidTap() {
        view.endEditing(true)
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
            self.commentDeleteButtonDidTapEvent.accept(id)
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
        emojiDidSelectEvent.accept(emojiID)
    }
    
}

//MARK: - ZoocAlertViewControllerDelegate

extension ArchiveViewController: ZoocAlertViewControllerDelegate {
    func exitButtonDidTap() {
        deleteArchiveEvent.accept(Void())
    }
    
}

extension ArchiveViewController: MFMailComposeViewControllerDelegate {
    private func sendMail(subject: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
            
                
                composeViewController.setToRecipients(["zooc0102@gmail.com"])
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
