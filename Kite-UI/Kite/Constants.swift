//
//  Constants.swift
//  Kite
//
//  Created by Adam on 8/19/22.
//

import Foundation
import UIKit
import AVFAudio

struct Constants {
    static var token = ""
    static var userId:Int64 = -1
    static var Font_Family = "PH"
    static var Font_Name = "PH-400RegularCaps"
    static var BaseColor = UIColor(red: 115/255, green: 196/255, blue: 255/255, alpha: 1.0)
    static var VoiceColor = UIColor(red: 107/255, green: 224/255, blue: 0/255, alpha: 1.0)
    static var PlaceholderColor = UIColor(red: 173/255, green: 166/255, blue: 166/255, alpha: 1.0)
    static var URL = "http://192.168.64.1"
    
    enum RecordingState {
        case recording, paused, stopped
    }
    
    static let RecordFileURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first?.appendingPathComponent("RecordFile.m4a")
    
    static var ImageURL = URL + ":93/image"
    static var VoiceURL = URL + ":93/voice"
    
    static let VoiceDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static let decoder = JSONDecoder()
    
}
