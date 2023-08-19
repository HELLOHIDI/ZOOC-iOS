//
//  MyRegisterPetRequest.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

struct MyRegisterPetRequest {
    var name: String
    var photo: UIImage?
    
    init(name: String = "", photo: UIImage? = nil) {
        self.name = name
        self.photo = photo
    }
}
