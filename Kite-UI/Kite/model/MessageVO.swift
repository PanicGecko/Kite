//
//  MessageVO.swift
//  Kite
//
//  Created by Adam on 8/17/22.
//

import Foundation

struct MessageVO: Codable {
    let chatId: Int
    let message: String
    let id: UUID
    let msgType: Int
    let deliveredTime: Date
    let from: Int
}
