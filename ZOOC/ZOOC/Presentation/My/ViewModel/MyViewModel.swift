//
//  MyViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/04.
//

import UIKit

import RxSwift
import RxCocoa

final class MyViewModel: ViewModelType {
    private let myUseCase: MyUseCase
    
    init(myUseCase: MyUseCase) {
        self.myUseCase = myUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let logoutButtonDidTapEvent: Observable<IndexPath>
        let deleteAccountButtonDidTapEvent: Observable<Void>
        let inviteCodeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var profileData = BehaviorRelay<UserResult?>(value: nil)
        var familyMemberData = BehaviorRelay<[UserResult]>(value: [])
        var petMemberData = BehaviorRelay<[PetResult]>(value: [])
        var inviteCode = BehaviorRelay<String?>(value: nil)
        var isloggedOut = BehaviorRelay<Bool?>(value: nil)
        var isDeletedAccount = BehaviorRelay<Bool?>(value: nil)
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
        
        input.logoutButtonDidTapEvent.subscribe(with: self, onNext: { owner, index in
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

extension MyViewModel {
    func getProfileData() -> UserResult? {
        return myUseCase.profileData.value
    }
    
    func getFamilyData() -> [UserResult] {
        return myUseCase.familyMemberData.value
    }
    
    func getPetData() -> [PetResult] {
        return myUseCase.petMemberData.value
    }
}
