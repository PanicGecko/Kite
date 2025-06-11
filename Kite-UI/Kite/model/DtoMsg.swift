//
//  DtoMsg.swift
//  Kite
//
//  Created by Adam on 7/31/23.
//

import Foundation

struct DtoMsg: Codable {
    let errorCode: String
    let msg: String
    let type: Int
    let message_v2: Message_v2
    
    init(errorCode: String, msg: String, type: Int, message_v2: Message_v2) {
        self.errorCode = errorCode
        self.msg = msg
        self.type = type
        self.message_v2 = message_v2
    }
    
}
