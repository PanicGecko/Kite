//
//  DtoUpdate.swift
//  Kite
//
//  Created by Adam on 8/3/23.
//

import Foundation

struct DtoUpdate: Codable {
    let errorCode: String
    let msg: String
    let success: String
    let data: [ChatVO]?
}
