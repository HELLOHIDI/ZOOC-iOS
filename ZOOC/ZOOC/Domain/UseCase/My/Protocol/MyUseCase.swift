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
    var inviteCode: BehaviorRelay<String?> { get }
    var isloggedOut: BehaviorRelay<Bool> { get }
    var isDeletedAccount: BehaviorRelay<Bool> { get }
    
    func requestMyPage()
    func logout()
    func deleteAccount()
    func getInviteCode()
}
