//
//  DtoImage.swift
//  Kite
//
//  Created by Adam on 1/31/24.
//

import Foundation

struct DtoImage: Codable     {
    let errorCode: String
    let msg: String
    let success: String
    let data: Data?
}
