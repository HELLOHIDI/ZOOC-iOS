//
//  EditPetProfileModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/06/22.
//

import UIKit

struct EditPetProfileRequest {
    var photo: Bool
    var nickName: String
    var file: UIImage?
    
    init(photo: Bool = true, nickName: String = "", file: UIImage? = nil) {
        self.photo = photo
        self.nickName = nickName
        self.file = file
    }
    
}
//init(hasPhoto: Bool = ,
//     nickName: String = "",
//     profileImage: UIImage? = nil) {
//    self.hasPhoto = hasPhoto
//    self.nickName = nickName
//    self.profileImage = profileImage
//}
