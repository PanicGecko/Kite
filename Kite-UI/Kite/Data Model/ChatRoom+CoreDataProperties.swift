//
//  ChatRoom+CoreDataProperties.swift
//  Kite
//
//  Created by Adam on 8/3/23.
//
//

import Foundation
import CoreData


extension ChatRoom {

    @NSManaged public var chatId: Int64
    @NSManaged public var chatName: String?
    @NSManaged public var lastSeen: Date?
    @NSManaged public var lastDelivered: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var memberNum: Int16
    @NSManaged public var messages: NSSet?
    @NSManaged public var createDate: Date?

}

// MARK: Generated accessors for messages
extension ChatRoom {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension ChatRoom : Identifiable {

}
