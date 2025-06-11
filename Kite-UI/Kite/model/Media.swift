//
//  Media.swift
//  Kite
//
//  Created by Adam on 1/31/24.
//

import Foundation
import UIKit

//struct Media {
//    let key: String
//    let filename: String
//    let data: Data
//    let mimeType: String
//    init?(withImage image: UIImage, forKey key: String, type: String) {
//        self.key = key
//        self.mimeType = "image/jpeg"
//        self.filename = UUID().uuidString + ".jpg"
//        guard let data = image.jpegData(compressionQuality: 0.7) else {
//            print("Media ----- could not convert ot jpeg")
//            return nil
//        }
//        self.data = data
//    }
//}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(data: Data, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = UUID().uuidString + ".jpg"
        self.data = data
    }
}
