//
//  ArchiveViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/04.
//

import Foundation

import RxCocoa
import RxSwift


final class ArchiveViewModel {
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let deleteArchiveButtonDidTap: Observable<Void>
        let swipeGestureEvent: Observable<HorizontalSwipe>
        let commentUploadButtonDidTapEvent: Observable<String>
        let emojiDidSelectEvent: Observable<Int>
        let commentReportButtonDidTapEvent: Observable<Int>
        let commentDeleteButtonDidTapEvent: Observable<Int>
    }
    
    struct Output {
        let archiveData = PublishRelay<ArchiveResult>()
        let commentData = PublishRelay<[CommentResult]>()
        let showGuideVC = PublishRelay<Bool>()
        let showToast = PublishRelay<ArchiveToastCase>()
        let dismissToHomeVC = PublishRelay<Void>()
    }
        
    private var archiveModel: ArchiveModel
    private var archvieData: ArchiveResult?
    private var commentData: [CommentResult] = []

    
    init(archiveModel: ArchiveModel) {
        self.archiveModel = archiveModel
    }
    
    func tranform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.showGuideVC.accept(UserDefaultsManager.isFirstAttemptArchive)
                owner.requestDetailArchiveAPI(request: owner.archiveModel, output: output)
            })
            .disposed(by: disposeBag)
        
        input.deleteArchiveButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.requestDeleteArchiveAPI(recordID: owner.archiveModel.recordID,
                                              output: output)
            })
            .disposed(by: disposeBag)
        
        input.swipeGestureEvent
            .subscribe(with: self, onNext: { owner, swipe in
                guard let data = owner.archvieData else { return output.showToast.accept(.unknown)}
                
                switch swipe {
                case .left:
                    var leftID = data.leftID
                    guard let leftID else { output.showToast.accept(.firstPage); return }
                    owner.archiveModel.recordID = leftID
                case .right:
                    var rightID = data.rightID
                    guard let rightID else { output.showToast.accept(.lastPage); return }
                    owner.archiveModel.recordID = rightID
                }
                
                owner.requestDetailArchiveAPI(request: owner.archiveModel, output: output)
                
            })
            .disposed(by: disposeBag)
        
        input.commentUploadButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, comment in
                owner.requestCommentsAPI(recordID: owner.archiveModel.recordID,
                                         text: comment,
                                         output: output)
            })
            .disposed(by: disposeBag)
        
        input.emojiDidSelectEvent
            .subscribe(with: self, onNext: { owner, emojiID in
                owner.requestEmojiCommentAPI(recordID: owner.archiveModel.recordID,
                                             emojiID: emojiID,
                                             output: output)
            })
            .disposed(by: disposeBag)
        
        input.commentReportButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
        
        input.commentDeleteButtonDidTapEvent
            .subscribe(with: self, onNext: { owner, commentID in
                owner.requestDeleteCommentAPI(commentID: commentID,
                                              output: output)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    
}

//MARK: - Zooc Service

extension ArchiveViewModel {
    func requestDetailArchiveAPI(request: ArchiveModel, output: Output) {
        HomeAPI.shared.getDetailPetArchive(recordID: request.recordID,
                                           petID: request.petID) { result in
            switch result {
            case .success(let data):
                guard let data = data as? ArchiveResult else {
                    return output.showToast.accept(.custom(message: "디코딩 오류가 발생했어요"))
                }
                self.archvieData = data
                self.commentData = data.comments
                output.archiveData.accept(data)
                output.commentData.accept(data.comments)
            case .requestErr(let msg):
                output.showToast.accept(.custom(message: msg))
            default:
                output.showToast.accept(.serverFail)
                
            }
        }
    }
    
    private func requestCommentsAPI(recordID: Int, text: String, output: Output) {
        HomeAPI.shared.postComment(recordID: recordID,
                                   comment: text) { result in
            switch result {
            case .success(let data):
                guard let data = data as? [CommentResult] else {
                    return output.showToast.accept(.custom(message: "디코딩 오류가 발생했어요"))
                }
                self.commentData = data
                output.commentData.accept(data)
                NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
            case .requestErr(let msg):
                output.showToast.accept(.custom(message: msg))
            default:
                output.showToast.accept(.serverFail)
                
            }
        }
    }
    
    private func requestEmojiCommentAPI(recordID: Int, emojiID: Int, output: Output) {
        
        HomeAPI.shared.postEmojiComment(recordID: recordID,
                                        emojiID: emojiID) { result in
            switch result {
            case .success(let data):
                guard let data = data as? [CommentResult] else {
                    return output.showToast.accept(.custom(message: "디코딩 오류가 발생했어요"))
                }
                self.commentData = data
                output.commentData.accept(data)
                NotificationCenter.default.post(name: .homeVCUpdate, object: nil)
            case .requestErr(let msg):
                output.showToast.accept(.custom(message: msg))
            default:
                output.showToast.accept(.serverFail)
                
            }
        }
    }
    
    private func requestDeleteArchiveAPI(recordID: Int, output: Output) {
        ArchiveAPI.shared.deleteArchive(recordID: recordID) { result in
            
            switch result {
            case .success:
                output.showToast.accept(.deleteArchiveSuccess)
                output.dismissToHomeVC.accept(Void())
            case .requestErr(let msg):
                output.showToast.accept(.custom(message: msg))
            default:
                output.showToast.accept(.serverFail)
                
            }
        }
    }
    
    private func requestDeleteCommentAPI(commentID: Int, output: Output) {
        ArchiveAPI.shared.deleteComment(commentID: commentID) { result in
            switch result {
            case .success:
                output.showToast.accept(.deleteCommentSuccess)
                self.requestDetailArchiveAPI(request: self.archiveModel, output: output)
            case .requestErr(let msg):
                output.showToast.accept(.custom(message: msg))
            default:
                output.showToast.accept(.serverFail)
                
            }
        }
    }
    
}

extension ArchiveViewModel {
    func getArchiveID() ->  Int {
        guard let archvieData else { return Int() }
        return archvieData.record.id
    }
    
    func getIsMyRecrod() -> Bool {
        guard let archvieData else { return Bool() }
        return archvieData.record.isMyRecord   
    }
    
    func getCommentIsEmoji(row: Int) -> Bool {
        guard commentData.count > row else { return Bool() }
        return commentData[row].isEmoji
    }
    
    func getCommentContent(row: Int) -> String? {
        guard commentData.count > row else { return String() }
        return commentData[row].content
    }
}
