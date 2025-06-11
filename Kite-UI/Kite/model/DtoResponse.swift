//
//  DtoResponse.swift
//  Kite
//
//  Created by Adam on 7/27/22.
//

import Foundation

struct DtoResponse: Decodable	 {
    let errorCode: String
    let msg: String
    let success: String
    let data: String?
}
