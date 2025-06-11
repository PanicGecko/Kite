//
//  ChatRoom+CoreDataClass.swift
//  Kite
//
//  Created by Adam on 8/3/23.
//
//

import Foundation
import CoreData


public class ChatRoom: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case chatName = "msgType"
        case chatId = "chatId"
        case lastSeen = "from"
        case lastDelivered = "deliveredTime"
        case lastMessage = "msgId"
        case memberNum = "chat"
        case messages = "messages"
        case newMessages = "newMessages"
        case createDate = "createDate"
        case individual = "individual"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey(rawValue: "context"),
                    let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
                    let entity = NSEntityDescription.entity(forEntityName: "ChatRoom", in: managedObjectContext) else {
                    fatalError("Failed to decode Chat")
                }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chatId = try container.decodeIfPresent(Int64.self, forKey: .chatId) ?? -1
        self.chatName = try container.decodeIfPresent(String.self, forKey: .chatName)
        self.lastSeen = try container.decodeIfPresent(Date.self, forKey: .lastSeen)
        self.lastDelivered = try container.decodeIfPresent(Date.self, forKey: .lastDelivered)
        self.memberNum = try container.decodeIfPresent(Int16.self, forKey: .memberNum) ?? -1
        self.messages = NSSet(array: try container.decode([Message].self, forKey: .messages))
        self.createDate = try container.decodeIfPresent(Date.self, forKey: .createDate)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoom> {
        return NSFetchRequest<ChatRoom>(entityName: "ChatRoom")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chatId, forKey: .chatId)
        try container.encode(chatName, forKey: .chatName)
        try container.encode(lastSeen, forKey: .lastSeen)
        try container.encode(lastDelivered, forKey: .lastDelivered)
        try container.encode(lastMessage, forKey: .lastMessage)
        try container.encode(memberNum, forKey: .memberNum)
        try container.encode(messages as! Set<Message>, forKey: .messages)
        try container.encode(createDate, forKey: .createDate)
    }

}
//extension CodingUserInfoKey {
//    static let context = CodingUserInfoKey(rawValue: "context")
//}
