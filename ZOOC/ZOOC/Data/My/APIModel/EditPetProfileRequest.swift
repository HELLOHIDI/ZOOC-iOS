//
//  EditPetProfileModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/06/22.
//

import UIKit

struct EditPetProfileRequest: Codable {
    var photo: Bool
    var nickName: String
    var file: Data
}
