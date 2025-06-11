//
//  Message+CoreDataClass.swift
//  Kite
//
//  Created by Adam on 8/3/23.
//
//

import Foundation
import CoreData


public class Message: NSManagedObject, Codable {
    
    @NSManaged public var id: UUID?
    @NSManaged public var message: String?
    @NSManaged public var delivered: Bool
    @NSManaged public var chatId: Int64
    @NSManaged public var from: Int64
    @NSManaged public var deliveredTime: Date?
    @NSManaged public var msgType: Int16
    @NSManaged public var blob: Data?
//    @NSManaged public var chat: ChatRoom?

    enum CodingKeys: String, CodingKey {
        case msgType = "msgType"
        case chatId = "chatId"
        case from = "from"
        case message = "message"
        case deliveredTime = "deliveredTime"
        case id = "id"
//        case chat = "chat"
        case delivered = "delivered"
        case blob = "blob"
    }
    
    required convenience public init(from decoder: Decoder) throws {

        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context,
                    let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
                    let entity = NSEntityDescription.entity(forEntityName: "Message", in: managedObjectContext) else {
                    fatalError("Failed to decode Message")
                }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.msgType = try container.decodeIfPresent(Int16.self, forKey: .msgType) ?? 1
        self.chatId = try container.decodeIfPresent(Int64.self, forKey: .chatId) ?? -1
        self.from = try container.decodeIfPresent(Int64.self, forKey: .from) ?? -1
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.deliveredTime = try container.decodeIfPresent(Date.self, forKey: .deliveredTime)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id)
        self.delivered = try container.decodeIfPresent(Bool.self, forKey: .delivered) ?? true
        self.blob = try container.decodeIfPresent(Data.self, forKey: .blob)
//        self.chat = try container.decodeIfPresent(ChatRoom.self, forKey: .chat)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(msgType, forKey: .msgType)
        try container.encode(chatId, forKey: .chatId)
        try container.encode(from, forKey: .from)
        try container.encode(message, forKey: .message)
        try container.encode(deliveredTime, forKey: .deliveredTime)
        try container.encode(id, forKey: .id)
//        try container.encode(chat, forKey: .chat)
        try container.encode(delivered, forKey: .delivered)
        try container.encode(blob, forKey: .blob)
    }

    
    
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}


extension Message : Identifiable {

}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}
