//
//  CreateUserVO.swift
//  Kite
//
//  Created by Adam on 7/29/22.
//

import Foundation

struct CreateUserVO: Codable {
    var firstName: String
    var lastName: String
    var username: String
    var password: String
    var email: String
    var birth: String
}
