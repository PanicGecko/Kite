//
//  Untitled.swift
//  Kite
//
//  Created by Adam on 6/8/25.
//

import Foundation

struct MultiResponse: Decodable     {
    let errorCode: String
    let msg: String
    let success: String
    let data: delivery?
}

struct delivery: Decodable {
    let deliveredTime: Date?
}
