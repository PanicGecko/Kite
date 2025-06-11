//
//  ChatVO.swift
//  Kite
//
//  Created by Adam on 8/3/23.
//

import Foundation

struct ChatVO: Codable {
    let chatId: Int
    let name: String
    let memberNum: Int16
    let messages: [Message_v2]?
    let createDate: Date?
}
