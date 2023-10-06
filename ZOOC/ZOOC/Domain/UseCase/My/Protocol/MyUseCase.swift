//
//  MyUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol MyUseCase {
    var profileData: BehaviorRelay<UserResult?> { get }
    var familyMemberData: BehaviorRelay<[UserResult]> { get }
    var petMemberData: BehaviorRelay<[PetResult]> { get }
    var inviteCode: PublishRelay<String> { get }
    var isloggedOut: PublishRelay<Bool> { get }
    var isDeletedAccount: PublishRelay<Bool> { get }
    
    func requestMyPage()
    func logout()
    func deleteAccount()
    func getInviteCode()
}
