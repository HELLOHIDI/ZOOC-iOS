//
//  SimpleResponse.swift
//  ZOOC
//
//  Created by 장석우 on 11/6/23.
//

import Foundation

struct SimpleResponse: Codable {
    var status: Int
    var success: Bool
    var message: String?
}
