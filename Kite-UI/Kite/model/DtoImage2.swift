//
//  DtoImage2.swift
//  Kite
//
//  Created by Adam on 7/11/24.
//

import Foundation

struct DtoImage2: Codable {
    let msgId: UUID
    let chatId: String
    let images: [String]
    let names: [String]
}
