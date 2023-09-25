//
//  MyResult.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/12.
//

import Foundation

// MARK: - MyResult
struct MyResult: Codable {
    let user: UserResult
    let familyMember: [UserResult]
    let pet: [PetResult]
}

// MARK: - User
struct UserResult: Codable {
    let id: Int
    var nickName: String
    var photo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nickName = "nick_name"
        case photo
    }
}

//// MARK: - Pet
//struct PetResult: Codable {
//    let id: Int
//    let name: String
//    let photo: String?
//}

