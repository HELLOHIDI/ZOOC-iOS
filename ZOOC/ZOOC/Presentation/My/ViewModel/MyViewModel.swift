//
//  MyViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/04.
//

import Foundation

import RxSwift
import RxCocoa

//protocol MyViewModelInput {
//    func viewWillAppearEvent()
//    func logoutButtonDidTapEvent()
//    func deleteAccountButtonDidTapEvent()
//    func inviteCodeButtonDidTapEvent()
//}
//
//protocol MyViewModelOutput {
//    var myFamilyMemberData: ObservablePattern<[UserResult]> { get }
//    var myPetMemberData: ObservablePattern<[PetResult]> { get }
//    var myProfileData: ObservablePattern<UserResult?> { get }
//    var inviteCode: ObservablePattern<String?> { get }
//    var logoutOutput: ObservablePattern<Bool?> { get }
//    var deleteAccoutOutput: ObservablePattern<Bool?> { get }
//}

//typealias MyViewModel = MyViewModelInput & MyViewModelOutput

import UIKit

import RxSwift
import RxCocoa

final class MyViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let myUseCase: MyUseCase
    
    init(myUseCase: MyUseCase) {
        self.myUseCase = myUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let logoutButtonDidTapEvent: Observable<Void>
        let deleteAccountButtonDidTapEvent: Observable<Void>
        let inviteCodeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var profileData = BehaviorRelay<UserResult?>(value: nil)
        var familyMemberData = BehaviorRelay<[UserResult]>(value: [])
        var petMemberData = BehaviorRelay<[PetResult]>(value: [])
        var inviteCode = BehaviorRelay<String?>(value: nil)
        var isloggedOut = BehaviorRelay<Bool>(value: false)
        var isDeletedAccount = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myUseCase.requestMyPage()
        }).disposed(by: disposeBag)
        
        input.inviteCodeButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myUseCase.getInviteCode()
        }).disposed(by: disposeBag)
        
        input.logoutButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myUseCase.logout()
        }).disposed(by: disposeBag)
        
        input.deleteAccountButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myUseCase.deleteAccount()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        myUseCase.profileData.subscribe(onNext: { profileData in
            output.profileData.accept(profileData)
        }).disposed(by: disposeBag)
        
        myUseCase.familyMemberData.subscribe(onNext: { familyMemberData in
            output.familyMemberData.accept(familyMemberData)
        }).disposed(by: disposeBag)
        
        myUseCase.petMemberData.subscribe(onNext: { petMemberData in
            output.petMemberData.accept(petMemberData)
        }).disposed(by: disposeBag)
        
        myUseCase.inviteCode.subscribe(onNext: { inviteCode in
            output.inviteCode.accept(inviteCode)
        }).disposed(by: disposeBag)
        
        myUseCase.isloggedOut.subscribe(onNext: { isloggedOut in
            output.isloggedOut.accept(isloggedOut)
        }).disposed(by: disposeBag)
        
        myUseCase.isDeletedAccount.subscribe(onNext: { isDeletedAccount in
            output.isDeletedAccount.accept(isDeletedAccount)
        }).disposed(by: disposeBag)
    }
}

