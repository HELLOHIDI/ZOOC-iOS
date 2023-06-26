//
//  URL.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation

public enum URLs{
    
    //MARK: - Family
    
    static let makeFamily = "/family"
    static let getNotice = "/alarm/list"
    static let myPage = "/family/mypage/{familyId}"
    static let getFamily = "/family"
    static let getInviteCode = "/family/code/{familyId}"
    static let registerPet = "/family/pets/{familyId}"
    static let joinFamily = "/family/user"
    static let patchPet = "/pet/{petId}/profile"
    
    //MARK: - User
    
    static let kakaoLogin = "/user/kakao/signin"
    static let appleLogin = "/user/apple/signin"
    static let refreshToken = "/user/refresh"
    static let editProfile = "/user/profile"
    static let signUp = "/user/create?code={code}"
    static let deleteUser = "/user"
    static let fcmToken = "/user/fcm_token"
    static let logout = "/user/signout"
    
    //MARK: - Record
    static let getMission = "/record/mission/{familyId}"
    static let totalPet = "/record/pet/{familyId}"
    static let postRecord = "/record/{familyId}"
    static let postMission = "/record/{familyId}"
    static let detailRecord = "/record/detail/{familyId}/{recordId}"
    static let detailPetRecord = "/record/detail/{familyId}/{petId}/{recordId}"
    static let totalRecord = "/record/{familyId}/{petId}"
    static let deleteRecord = "/record/{recordId}"
    
    //MARK: - Comment
    
    static let postComment = "/comment/{recordId}"
    static let postEmojiComment = "/comment/emoji/{recordId}"
    static let deleteComment = "/record/{commentId}"
    
}
