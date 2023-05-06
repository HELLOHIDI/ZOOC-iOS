//
//  GenericResponse.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    var status: Int
    var success: Bool
    var message: String?
    var data: T?
}
