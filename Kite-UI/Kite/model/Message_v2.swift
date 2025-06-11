//
//  Message_v2.swift
//  Kite
//
//  Created by Adam on 7/22/23.
//

import Foundation

struct Message_v2: Codable {
    let id: UUID?
    let msgType: Int
    let from: Int
    let message: String
    let chatId: Int
    var deliveredTime: Date?
    let toUser: Int?
    let viewCount: Int?
    var blob: Data?
    let chatSize: Int?
    
    init(id: UUID, msgType: Int, from: Int, message: String, chatId: Int, deliveredTime: Date?, toUser: Int, viewCount: Int, chatSize: Int) {
        self.id = id
        self.msgType = msgType
        self.from = from
        self.message = message
        self.chatId = chatId
        self.deliveredTime = deliveredTime
        self.toUser = toUser
        self.viewCount = viewCount
        self.blob = nil
        self.chatSize = chatSize
    }
    
    init(id: UUID, msgType: Int, from: Int, message: String, chatId: Int, deliveredTime: Date?, toUser: Int, viewCount: Int, blob: Data, chatSize: Int?) {
        self.id = id
        self.msgType = msgType
        self.from = from
        self.message = message
        self.chatId = chatId
        self.deliveredTime = deliveredTime
        self.toUser = toUser
        self.viewCount = viewCount
        self.blob = blob
        self.chatSize = chatSize
    }
    
    init(id: UUID) {
        self.id = id
        self.msgType = -1
        self.from = -1
        self.message = ""
        self.chatId = -1
        self.deliveredTime = nil
        self.toUser = nil
        self.viewCount = nil
        self.blob = nil
        self.chatSize = 0
    }
}
