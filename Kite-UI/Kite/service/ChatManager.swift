//
//  ChatManager.swift
//  Kite
//
//  Created by Adam on 8/16/22.
//

import Starscream
import Foundation
import UIKit
import CoreData
import DequeModule
import AVFoundation

protocol ChatDelegate: AnyObject {
    func incomingMsg(chatId: Int64)
    func newChat(chatId: ChatRoom)
    func didErrorHappen(msg: String)
    func didResolveError()
    func updateChats()
    func updateSeen()
    func invalidToken()
    func openOldChat(chatRoom: ChatRoom)
}

protocol MessageDelegate: AnyObject {
    func newMessage(msg: Message, del: Bool)
    func didErrorHappen(msg: String)
    func initMessages(del: [Message], undel: [Message])
    func updateMsg(msg: Message)
    func didResolveError()
}

protocol ChatServiceDelegate: AnyObject {
    func updateSearch(users: Array<UserVO>)
    func didErrorHappen(msg: String)
    func chatCreated()
}

class ChatManager: WebSocketDelegate{
    
    static let shared = ChatManager()
    private init() {}
    
    var socket: WebSocket?
    var isConnected = false
    var isError = false
    
    weak var chatDelegate: ChatDelegate?
    weak var messageDelegate: MessageDelegate?
    weak var chatServiceDelegate: ChatServiceDelegate?
    
    let createChatURL = Constants.URL + ":80/chat/create"
    let searchURL = Constants.URL + ":80/chat/search"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let dateFormatter = DateFormatter()
    
    
    //Audio stuff
    var audioConverter: AVAudioConverter?
    var compressedFormat: AVAudioFormat?
    
    
    func initSocket() {
        print("in initSocket")
        var request = URLRequest(url: URL(string: Constants.URL + ":82/chat")!)
        request.timeoutInterval = 5
        request.setValue(KeychainWrapper.standard.string(forKey: "token"), forHTTPHeaderField: "X-Authentication")
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        dateFormatter.locale    = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone  = TimeZone(identifier: "America/New_York")
        print("finish initsocket")
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let dictionary):
            isConnected = true
            if isError {
                chatDelegate?.didResolveError()
                messageDelegate?.didResolveError()
                isError = false
            }
            print("Websocket is connected: \(dictionary)")
            break
        case .disconnected(let string, let uInt16):
            if isConnected {
                chatDelegate?.didErrorHappen(msg: "Websocket Disconnected")
                messageDelegate?.didErrorHappen(msg: "Websocket Disconnected")
                isError = true
            }
            isConnected = false
            print("websocket is disconnnected: \(string), with code: \(uInt16)")
            
            break
        case .text(let msg):
            print("Received text: \(msg)")
            receviedMessage(msg: msg)
            break
        case .binary(let data):
            print("Received data: \(data)")
            break
        case .pong(let optional):
            break
        case .ping(let optional):
            break
        case .error(let optional):
            if isConnected {
                chatDelegate?.didErrorHappen(msg: "Error Happended with Weboscket: \(optional)")
                messageDelegate?.didErrorHappen(msg: "Error Happended with Weboscket: \(optional)")
                isError = true
            }
            isConnected = false
            
            print("isConnected error \(optional)")
        case .viabilityChanged(let bool):
            print("viabiltiyChanged error \(bool)")
            break
        case .reconnectSuggested(let bool):
            print("reconnectSuggested error \(bool)")
            break
        case .cancelled:
            if isConnected {
                chatDelegate?.didErrorHappen(msg: "Error Happended with Weboscket cancelled")
                messageDelegate?.didErrorHappen(msg: "Error Happended with Weboscket cancelled")
                isError = true
            }
            isConnected = false
        }
    }
    
    func receviedMessage(msg: String) {
        do {
            
            let incoming = try decoder.decode(DtoMsg.self, from: Data(msg.utf8))
            if incoming.errorCode == "200" {
                print("receviedMessage 200")
                // 1 - delivered message, 0 - incoming message
                if incoming.type == 0 {
                    let newMessage = Message(context: self.context)
                    newMessage.chatId = Int64(incoming.message_v2.chatId)
                    newMessage.deliveredTime = incoming.message_v2.deliveredTime
                    newMessage.from = Int64(incoming.message_v2.from)
                    newMessage.message = incoming.message_v2.message
                    newMessage.id = incoming.message_v2.id
                    newMessage.msgType = Int16(incoming.message_v2.msgType)
                    newMessage.delivered = true
                    updateChatView(newMessage: newMessage)
//                    saveMsg()
                    outgoingMsg(msg: newMessage, type: 1, errorCode: "200", errorMsg: "good")
                    self.messageDelegate?.newMessage(msg: newMessage, del: true)
//                    self.chatDelegate?.incomingMsg(chatId: Int64(incoming.message_v2.chatId))
                } else if incoming.type == 1 {
                    if let newMessage = getMessageById(msgId: incoming.message_v2.id!) {
                        newMessage.deliveredTime = incoming.message_v2.deliveredTime
                        newMessage.delivered = true
                        //                        updateChatView(newMessage: newMessage)
                        print("ChatManager reciveidMessage in type 1")
                        saveMsg(chatId: newMessage.chatId)
                        updateChatView(newMessage: newMessage)
                        self.messageDelegate?.updateMsg(msg: newMessage)
                        //                        self.chatDelegate?.incomingMsg()
                    }
                    
                } else if incoming.type == 5 {//5 - new chat was created
                    print("incoming getting new chat")
                    let newChat = ChatRoom(context: self.context)
                    newChat.chatId = Int64(incoming.message_v2.chatId)
                    newChat.lastMessage = "New Chat"
                    newChat.memberNum = Int16(incoming.message_v2.chatSize!)
                    newChat.createDate = incoming.message_v2.deliveredTime
                    newChat.chatName = incoming.message_v2.message
                    newChat.lastSeen = nil
                    newChat.lastDelivered = incoming.message_v2.deliveredTime
                    
                    saveMsg(chatId: newChat.chatId)
                    outgoingChatMsg(msgId: incoming.message_v2.id!, errorCode: "200", errorMsg: "good")
                    self.chatDelegate?.newChat(chatId: newChat)
                }
                
                
            } else {
                print("receivedMessage message has error code: \(incoming.errorCode), msg: \(incoming.msg)")
            }
        } catch {
            print("ChatManager receviedMessage error: \(error)")
        }
    }
    
    func updateChatView(newMessage: Message) {
        guard let chatroom = getChatRoom(chatId: Int(newMessage.chatId)) else {
            print("updateChatView gond wrong")
            return
        }
        chatroom.lastDelivered = newMessage.deliveredTime
        if newMessage.msgType == 3 {
            chatroom.lastMessage = "Image"
        } else {
            chatroom.lastMessage = newMessage.message
        }
        
        saveMsg(chatId: chatroom.chatId)
    }
    
    func setChatLastSeen(chatroom: ChatRoom) {
        chatroom.lastSeen = Date()
        do {
            try context.save()
        } catch {
            print("setChatLastSeen \(error)")
        }
    }
    
    func sendMessage(msg: String?, chatId: Int) {
        let outMessage = Message(context: context)
        outMessage.id = UUID(uuidString: UUID().uuidString)
        outMessage.chatId = Int64(chatId)
        outMessage.deliveredTime = Date.distantFuture
        outMessage.delivered = false
        outMessage.from = Int64(KeychainWrapper.standard.integer(forKey: "userId")!)
        outMessage.message = msg
        outMessage.msgType = 1
        let theChat = getChatRoom(chatId: chatId)
        theChat?.lastMessage = msg
        
        //Test Audio
//        if msgType == 1 {
//            print("ChatManager: sendMessage - msgType is audio")
//            self.messageDelegate?.newMessage(msg: outMessage, del: false)
//            return
//        }
        //
        
        
        if saveMsg(chatId: Int64(chatId)) {
            outgoingMsg(msg: outMessage, type: 0, errorCode: "200", errorMsg: "All Good")
        } else {
            outgoingMsg(msg: nil, type: 0, errorCode: "451", errorMsg: "All Good")
        }
        self.messageDelegate?.newMessage(msg: outMessage, del: false)
    }
    func outgoingChatMsg(msgId: UUID, errorCode: String, errorMsg: String) {
        
        var message = Message_v2(id: msgId, msgType: 0, from: 0, message: "", chatId: 0, deliveredTime: nil, toUser: 0, viewCount: 0, chatSize: 0)
        
        
        let dto = DtoMsg(errorCode: errorCode, msg: errorMsg, type: 1, message_v2: message)
        do {
            let jsonData = try encoder.encode(dto)
            self.socket?.write(string: String(data: jsonData, encoding: .utf8)!)
        } catch {
            print("Error with outgoing json: \(error)")
        }
        
    }
    func outgoingMsg(msg: Message?, type: Int, errorCode: String, errorMsg: String) {
        
        var message: Message_v2?
        
        if msg == nil {
            message = nil
        } else if type == 1 {
            message = Message_v2(id: (msg!.id!))
        } else {
            message = Message_v2(id: msg!.id!, msgType: Int(msg!.msgType), from: Int(msg!.from), message: msg!.message ?? "", chatId: Int(msg!.chatId), deliveredTime: nil, toUser: 0, viewCount: 0, chatSize: 0)
        }
        
        let dto = DtoMsg(errorCode: errorCode, msg: errorMsg, type: type, message_v2: message!)
        do {
            let jsonData = try encoder.encode(dto)
            self.socket?.write(string: String(data: jsonData, encoding: .utf8)!)
        } catch {
            print("Error with outgoing json: \(error)")
        }
        
    }
    
    func getMessageById(msgId: UUID) -> Message?{
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        guard let uuidQuery = UUID(uuidString: msgId.uuidString) else {
            print("UUID converting gone wrong")
            return nil
        }
        request.predicate = NSPredicate(format: "id == %@", msgId as CVarArg)
        do {
            let msgs = try context.fetch(request)
            print("ChatManager getMessageBYId: \(msgs.count)")
//            print("ChatManager getMessageBYId msgId: \(msgId.uuidString) id of reuslt: \(msgs.first?.id), now as string: \(msgs.first!.id?.uuidString)")
            return msgs.first
        } catch {
            print("Error fetching id of messages: \(error)")
        }
        return nil
        
    }
    
    func getDelMessagesByChatRoom(chatRoom: ChatRoom) {
        print("ChatManager getDelMessagesByChatRoom \(chatRoom.chatId)")
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "delivered == YES AND chatId == %i", chatRoom.chatId)
        request.sortDescriptors = [NSSortDescriptor(key: "deliveredTime", ascending: true)]
        request.fetchLimit = 20
        
        let request2: NSFetchRequest<Message> = Message.fetchRequest()
        request2.predicate = NSPredicate(format: "delivered == NO AND chatId == %i", chatRoom.chatId)
        request2.sortDescriptors = [NSSortDescriptor(key: "deliveredTime", ascending: true)]
        
        do {
            let del = try context.fetch(request)
            let undel = try context.fetch(request2)
            print("ChatManager getDelMessagesByChatRoom del: \(del.count), undel: \(undel.count)")
            self.messageDelegate?.initMessages(del: del, undel: undel)
        } catch {
            print("Error getting Messages by ChatRoom")
            self.messageDelegate?.didErrorHappen(msg: "Get Messages by chatroom")
        }
    }
    
    func saveMsg(chatId: Int64) -> Bool{
        do {
            try context.save()
            self.chatDelegate?.incomingMsg(chatId: chatId)
            return true
        } catch {
            print("saveMsg Error: \(error)")
            self.chatDelegate?.didErrorHappen(msg: "saveMsg: \(error)")
            return false
        }
    }
    
    func getChats() -> Deque<ChatRoom>{
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastDelivered", ascending: true)]
        do {
            let chatItems: Deque<ChatRoom> = Deque(try context.fetch(request))
            return chatItems
        } catch {
            print("Error fetching chats: \(error)")
        }
        return []
    }
    
    func deleteAllData() {
        print("ChatManager: deleteAllData start")
        socket?.disconnect()
        let requestChatRoom: NSFetchRequest<NSFetchRequestResult> = ChatRoom.fetchRequest()
        let deleteChatRoomRequest = NSBatchDeleteRequest(fetchRequest: requestChatRoom)
        let requestMsg: NSFetchRequest<NSFetchRequestResult> = Message.fetchRequest()
        let deleteMsgRequest = NSBatchDeleteRequest(fetchRequest: requestMsg)
        do {
            try? context.execute(deleteMsgRequest)
            try? context.execute(deleteChatRoomRequest)
        } catch {
            print("ChatManager delteteAllData error: \(error)")
        }
        print("ChatManager: deleteAllData end")
    }
    
    func getLatestChats() {
        print("in getChats")
        if let url = URL(string: Constants.URL + ":80/chat/latest") {
            var request = URLRequest(url: url)
//            let string = "{\"members\":\(members)}"
//            guard let jsonData = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!) else {
//                print("createChat error url")
//                return
//            }
//            print("createChat json send: \(jsonData)")
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(KeychainWrapper.standard.string(forKey: "token"), forHTTPHeaderField: "X-Authentication")
//            request.httpBody = string.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("createChat : error")
                    return
                }
                if let safeData = data {
                    do {
                        let contextDecoder = JSONDecoder()
                        
                        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        contextDecoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                        contextDecoder.userInfo[CodingUserInfoKey.context!] = self.context
                        let responseDto = try contextDecoder.decode(DtoUpdate.self, from: safeData)
                        
                        //Check if token is valid
                        //Token is not good - return to login
                        if responseDto.errorCode == "501" {
                            self.chatDelegate?.invalidToken()
                            self.socket?.disconnect()
                            KeychainWrapper.standard.set("", forKey: "token")
                            KeychainWrapper.standard.set("", forKey: "lastLoginDate")
                            return
                        }
                        
                        //Get the new token from the response header
                        let response = response as! HTTPURLResponse
                        let newToken = response.value(forHTTPHeaderField: "X-Authentication")
                        if newToken == nil {
                            // if the token doesn't exist in the response header
                            self.chatDelegate?.invalidToken()
                            return
                        }
                        KeychainWrapper.standard.set(newToken!, forKey: "token")
                        
                        //Update data for lastlogintime
                        let df = DateFormatter()
                        df.dateFormat = "MM-dd-yyyy"
                        KeychainWrapper.standard.set(df.string(from: Date()), forKey: "lastLoginDate")
                        
                        
                        var ids: [String] = []
                        for chat in responseDto.data ?? [] {
                            print("getLatestChats reponseDTo chatName: \(chat.name)")
                            var newChat: ChatRoom? = self.getChatRoom(chatId: chat.chatId) ?? nil
                            if newChat == nil {
                                newChat = ChatRoom(context: self.context)
                                newChat?.chatId = Int64(chat.chatId)
                                newChat?.chatName = chat.name
                            }
                            
                            newChat?.memberNum = chat.memberNum
                            
                            if chat.messages != nil || !chat.messages!.isEmpty {
                                newChat?.lastMessage = chat.messages!.last?.message
                                newChat?.lastDelivered = chat.messages!.last?.deliveredTime
                                for msg in chat.messages! {
//                                    ids.append(UUID(uuidString: msg.id!.uuidString)!)
                                    ids.append(msg.id!.uuidString)
                                    print("getLatestChat appeding to ids")
                                    if msg.msgType == 5 {
                                        newChat?.lastMessage = "New Chat"
                                        print("ChatManager: getLatestChats msg type is 5 name is: \(msg.message)")
                                        continue
                                    }
                                   
                                    let newMessage = Message(context: self.context)
                                    newMessage.chatId = Int64(msg.chatId)
                                    newMessage.deliveredTime = msg.deliveredTime
                                    newMessage.from = Int64(msg.from)
                                    newMessage.message = msg.message
                                    newMessage.id = msg.id
                                    newMessage.msgType = Int16(msg.msgType)
                                    newMessage.delivered = true
                                }
                            }
                        }
                        try self.context.save()
                        self.chatDelegate?.updateChats()
                        print("getLatestchats before rerutnr chats: \(ids.count)")
                        if ids.count > 0 {
                            self.returnChats(ids: ids)
                        }
                    } catch {
                        print("getLatestchat something went wrong: \(error)")
                    }
                }
                
            }
            task.resume()
            
        }
    }
    
    func returnChats(ids: [String]) {
        print("in returnChats")
        if let url = URL(string: Constants.URL + ":80/chat/returnLatest") {
            var request = URLRequest(url: url)
            
            guard let data = try? encoder.encode(ids) else {
                print("returnChats json wront")
                return
            }
            let jsonData: String? = String(data: data, encoding: .utf8)
            
            
            print("returnChats json send: \(jsonData)")
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(KeychainWrapper.standard.string(forKey: "token"), forHTTPHeaderField: "X-Authentication")
            request.httpBody = jsonData?.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("returnchats : error")
                    return
                }
                if let safeData = data {
                    do {
                        let responseDto = try self.decoder.decode(DtoResponse.self, from: safeData)
                        if responseDto.errorCode == "200" {
                            print("returnChats All GOOD")
                        } else {
                            print("return Chats NOT GOOD")
                        }
                        
                    } catch {
                        print("returnChats something went wrong: \(error)")
                    }
                }
                
            }
            task.resume()
            
        }
    }
    
    func getChatRoom(chatId: Int) -> ChatRoom? {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        request.predicate = NSPredicate(format: "chatId == %i", chatId)
        do {
            let chatRoom = try context.fetch(request)
            return chatRoom.first
        } catch {
            print("Error fetching ChatRoom: \(error)")
        }
        return nil
    }
    
    func searchUser(input: String) {
        print("in searchUser")
        if let url = URL(string: searchURL) {
            var request = URLRequest(url: url)
            let string = "{\"search\":\"\(input)\"}"
            guard let jsonData = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!) else {
                print("jsonData something went wrong")
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(KeychainWrapper.standard.string(forKey: "token"), forHTTPHeaderField: "X-Authentication")
            request.httpBody = string.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("searchUser : error")
                    return
                }
                
                if let safeData = data {
                    
                    print("searchUser safeData1 : \(String(decoding: safeData, as: UTF8.self))")
                    do {
                        let responseDto = try self.decoder.decode(DtoResponse.self, from: safeData)
                        if responseDto.errorCode == "200" {
                            print("searchUser safeData: \(responseDto.data)")
                            let users = try self.decoder.decode(SearchUserList.self, from: (responseDto.data?.data(using: .utf8))!)
                            self.chatServiceDelegate?.updateSearch(users: users.users)
                        } else {
                            self.chatServiceDelegate?.didErrorHappen(msg: "searchUser error: \(responseDto.msg)")
                        }
                    } catch {
                        self.chatServiceDelegate?.didErrorHappen(msg: "searchUser catch: \(error)")
                    }
                }
                
            }
            task.resume()
            
        } else {
            print("in searchUser not url")
        }
    }
    
    func checkChatRoom(username: String) -> ChatRoom? {
        let request: NSFetchRequest<ChatRoom> = ChatRoom.fetchRequest()
        request.predicate = NSPredicate(format: "memberNum == 2 AND chatName ==[c] %@", username)
        do {
            let chatRoom = try context.fetch(request)
            return chatRoom.first
        } catch {
            print("Error fetching ChatRoom: \(error)")
        }
        return nil
    }
    
    func createChat(members: Set<Int>, chatName: String) {
        //Check if the individual chat exists
        if members.count == 1 {
            print("createChat members count is 1")
            // indivual chat
            if let theChat = checkChatRoom(username: chatName) {
                print("createChat Individual chat exists")
                chatServiceDelegate?.chatCreated()
                chatDelegate?.openOldChat(chatRoom: theChat)
                return
            }
        }
        
        
        
        print("in createChat")
        if let url = URL(string: createChatURL) {
            var request = URLRequest(url: url)
            let string = "{\"chatName\":\"\(chatName)\", \"members\":\(members)}"
            guard let jsonData = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!) else {
                print("createChat error url")
                return
            }
            print("createChat json send: \(jsonData)")
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(KeychainWrapper.standard.string(forKey: "token"), forHTTPHeaderField: "X-Authentication")
            request.httpBody = string.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("createChat : error")
                    return
                }
                
                if let safeData = data {
                    do {
                        let responseDto = try self.decoder.decode(DtoMsg.self, from: safeData)
                        if responseDto.errorCode == "200" {
                            print("createChat succedded")
                            let newChat = ChatRoom(context: self.context)
                            newChat.chatId = Int64(responseDto.message_v2.chatId)
                            newChat.lastMessage = "New Chat"
                            newChat.memberNum = Int16(responseDto.message_v2.chatSize!)
                            newChat.createDate = responseDto.message_v2.deliveredTime
                            newChat.chatName = chatName
                            newChat.lastSeen = nil
                            newChat.lastDelivered = responseDto.message_v2.deliveredTime
                            self.saveMsg(chatId: newChat.chatId)
                            self.chatServiceDelegate?.chatCreated()
                            self.chatDelegate?.newChat(chatId: newChat)
                            
                        } else {
                            self.chatServiceDelegate?.didErrorHappen(msg: "createChat error: \(responseDto.msg)")
                        }
                    } catch {
                        self.chatServiceDelegate?.didErrorHappen(msg: "createChat catch: \(error)")
                    }
                }
                
            }
            task.resume()
            
        }
    }
    
    func updateLastSeen(chatRoom: ChatRoom) {
        chatRoom.lastSeen = Date()
        do {
            try context.save()
            self.chatDelegate?.updateSeen()
        } catch {
            print("updateLastSeen Error: \(error)")
            self.chatDelegate?.didErrorHappen(msg: "saveMsg: \(error)")
        }
    }
    
    func receiveAudioMessage(message: Message) {
        if message.blob == nil {
            return
        }
//        message.blob = decodeAudio(data: message.blob!)
        
    }
    
    
    //Image Handler
    
    func getImageById(imgId: String) -> Data?{
        let request: NSFetchRequest<Images> = Images.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", imgId)
        do {
            let imgData = try context.fetch(request)
            if imgData.count < 1 {
                return nil
            }
            
            print("getImageById- name: \(imgData.count)")
            return imgData.first!.data
        } catch {
            print("getImagebyID: error: \(error)")
            return nil
        }
        return nil
    }
    
    func getVoiceById(audioId: String) -> Data? {
        let request: NSFetchRequest<Voices> = Voices.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", audioId)
        do {
            let imgData = try context.fetch(request)
            if imgData.count < 1 {
                return nil
            }
            
            print("getAudioById- name: \(imgData.count)")
            return imgData.first!.data
        } catch {
            print("getAudiobyID: error: \(error)")
            return nil
        }
        return nil
    }
    
//    func sendPhotos(photos: [Data], chatId: Int) {
//
//        print("sendPhotos photo count: \(photos.count)")
//
//
//        //Photo dict
//        var imgDict : [String: Data] = [String: Data]()
//        var parameters = [
//          [
//            "key": "chatId",
//            "value": "4",
//            "type": "text"
//          ],
//          [
//            "key": "images",
//            "src": "/Users/adam/Documents/Book1.xlsx",
//            "type": "file"
//          ],
//          [
//            "key": "images",
//            "src": "/Users/adam/Documents/collegereport.pdf",
//            "type": "file"
//          ]] as [[String: Any]]
//
//        for i in photos {
//
//        }
//
////        var names:[String] = []
////        for i in photos {
////            let imgId = UUID().uuidString
////            names.append(imgId)
////        }
//
//
//
//
//        let newMsg = Message(context: context)
//        newMsg.chatId = Int64(chatId)
//        newMsg.msgType = 3
//        newMsg.deliveredTime = Date.distantFuture
//        newMsg.delivered = false
//        newMsg.from = Int64(KeychainWrapper.standard.integer(forKey: "userId")!)
//        newMsg.message = names.joined(separator: ",")
//        newMsg.id = UUID(uuidString: UUID().uuidString)
//
//        var imgs: [Images] = []
//
//
//        var request = MultipartFormDataRequest(url: URL(string: Constants.ImageURL + "/upload")!)
////        request.addDataField(named: "images", data: photos[0], mimeType: "img/jpeg")
//        for i in photos.indices {
//            request.addDataField(named: "images", data: photos[i], mimeType: "application/json", imgId: names[i])
//            let img = Images(context: context)
//            img.id = names[i]
//            img.data = photos[i]
//            imgs.append(img)
//        }
//
//        do {
//            try self.context.save()
//            print("ChatManager: sendPhotos - Saved")
//        } catch {
//            imgs = []
//            print("ChatManager: sendPhotos - error saving photos \(error)")
//            return
//        }
//
//        self.messageDelegate?.newMessage(msg: newMsg, del: false)
//
//
//        request.addTextField(named: "chatId", value: String(chatId))
//        request.addTextField(named: "msgId", value: newMsg.id!.uuidString)
//        request.addTextField(named: "names", value: names.joined(separator: ","))
//
//        let task = URLSession.shared.dataTask(with: request.asURLRequest()) { data, response, error in
//            if error != nil {
//                print("ChatManager: sendPhotots - sending photots went wrong: \(error)")
//                return
//            }
//            if let safeData = data {
//                do {
//                    print("Chatmanager: got data back: ")
//                    let responseDto = try JSONDecoder().decode(DtoImage.self, from: safeData)
//                    if responseDto.errorCode == "201" {
//                        print("DtoImage all good: ")
//                        //save msg
//
//                    }
//                } catch {
//                    print("Sending Image error: \(error)")
//                }
//            }
//        }
//        task.resume()
//    }
    
    func savePhoto(imgId: String, photo: Data) async {
        var img = Images(context: context)
        img.id = imgId
        img.data = photo
        do {
            try self.context.save()
        } catch {
            print("savePhoto error - \(error)")
        }
    }
    
    func sendPhotos(photos: [Data], chatId: Int) {
        
        print("sendPhotos photo count: \(photos.count)")
        
        
        //Photo dict
        
        
        var imgs: [Images] = []
        var names: [String] = []
        var pics: [String] = []
        
        
        for i in photos {
            let imgId = UUID().uuidString
            let img = Images(context: context)
            img.id = imgId
            img.data = i
            imgs.append(img)
            names.append(imgId)
            pics.append(i.base64EncodedString(options: .lineLength64Characters))
        }
        
        
        
        
        
        
        let newMsg = Message(context: context)
        newMsg.chatId = Int64(chatId)
        newMsg.msgType = 3
        newMsg.deliveredTime = Date.distantFuture
        newMsg.delivered = false
        newMsg.from = Int64(KeychainWrapper.standard.integer(forKey: "userId")!)
        newMsg.message = names.joined(separator: ",")
        newMsg.id = UUID(uuidString: UUID().uuidString)
        
        do {
            try self.context.save()
            print("ChatManager: sendPhotos - Saved")
        } catch {
            imgs = []
            print("ChatManager: sendPhotos - error saving photos \(error)")
            return
        }
        
        self.messageDelegate?.newMessage(msg: newMsg, del: false)
        
        
        if let url = URL(string: Constants.ImageURL + "/upload") {
            var request = URLRequest(url: url)
            guard let jsonData = try? JSONEncoder().encode(DtoImage2(msgId: newMsg.id!, chatId: String(chatId), images: pics, names: names)) else {
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(KeychainWrapper.standard.string(forKey: "token")!, forHTTPHeaderField: "X-Authentication")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("ChatManager: sendPhotots - sending photots went wrong: \(error)")
                    return
                }
                
                if let safeData = data {
                    do {
                        print("Chatmanager: got data back: ")
                        let responseDto = try self.decoder.decode(MultiResponse.self, from: safeData)
                        if responseDto.errorCode == "200" {
                            print("DtoImage all good: ")
                            //save msg
                            newMsg.delivered = true
                            newMsg.deliveredTime = responseDto.data?.deliveredTime
                            self.saveMsg(chatId: newMsg.chatId)
                            self.messageDelegate?.updateMsg(msg: newMsg)
                            
                        }
                    } catch {
                        print("Sending Image error: \(error)")
                        print("sendPhotos error url: \(request.url?.description)")
                    }
                }
            }
            task.resume()
        }
        
        
        
        
        
    }
    
    
//    func sendPhotos(photos: [Data], chatId: Int) {
//
//        print("sendPhotos photo count: \(photos.count)")
//
//
//        //Photo dict
//        var imgDict : [String: Data] = [String: Data]()
//        var parameters = [
//            [
//              "key": "X-Authentication",
//              "value": KeychainWrapper.standard.string(forKey: "token"),
//              "type": "text"
//            ],
//          [
//            "key": "chatId",
//            "value": String(chatId),
//            "type": "text"
//          ],
//          ] as [[String: Any]]
//
//        var imgs: [Images] = []
//
//        for i in photos {
//            let imgId = UUID().uuidString
//            parameters.append([
//                "key": "images",
//                "value": photos.first!.base64EncodedString(options: .lineLength64Characters),
//                "type": "text"
//            ])
//            imgDict[imgId] = i
//
//            let img = Images(context: context)
//            img.id = imgId
//            img.data = i
//            imgs.append(img)
//        }
//
////        var names:[String] = []
////        for i in photos {
////            let imgId = UUID().uuidString
////            names.append(imgId)
////        }
//
//
//
//
//        let newMsg = Message(context: context)
//        newMsg.chatId = Int64(chatId)
//        newMsg.msgType = 3
//        newMsg.deliveredTime = Date.distantFuture
//        newMsg.delivered = false
//        newMsg.from = Int64(KeychainWrapper.standard.integer(forKey: "userId")!)
//        newMsg.message = imgDict.keys.joined(separator: ",")
//        newMsg.id = UUID(uuidString: UUID().uuidString)
//
//        parameters.append([
//            "key": "msgId",
//            "value": newMsg.id!.uuidString,
//            "type": "text"
//          ])
//
//
//
//        do {
//            try self.context.save()
//            print("ChatManager: sendPhotos - Saved")
//        } catch {
//            imgs = []
//            print("ChatManager: sendPhotos - error saving photos \(error)")
//            return
//        }
//
//        self.messageDelegate?.newMessage(msg: newMsg, del: false)
//
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var body = ""
//        var error: Error? = nil
//        for param in parameters {
//            if param["disabled"] != nil { continue }
//            let paramName = param["key"]!
//            body += "--\(boundary)\r\n"
//            body += "Content-Disposition:form-data; name=\"\(paramName)\""
//            if param["contentType"] != nil {
//                body += "\r\nContent-Type: \(param["contentType"] as! String)"
//            }
//            let paramType = param["type"] as! String
//            if paramType == "text" {
//                let paramValue = param["value"] as! String
//                body += "\r\n\r\n\(paramValue)\r\n"
//            } else {
//                let paramSrc = param["src"] as! String
//                let fileContent = imgDict[paramSrc]!.base64EncodedString(options: .lineLength64Characters)
////                String(data: imgDict[paramSrc]!.base64EncodedData(), encoding: .utf8)!
//                body += "; filename=\"\(paramSrc)\"\r\n"
//                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//
//            }
//        }
//
//        body += "--\(boundary)--\r\n";
//        let postData = body.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: "http://192.168.64.1:93/image/upload")!,timeoutInterval: Double.infinity)
//        request.addValue(KeychainWrapper.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "X-Authentication")
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                print("ChatManager: sendPhotots - sending photots went wrong: \(error)")
//                return
//            }
//            if let safeData = data {
//                do {
//                    print("Chatmanager: got data back: ")
//                    let responseDto = try JSONDecoder().decode(DtoImage.self, from: safeData)
//                    if responseDto.errorCode == "201" {
//                        print("DtoImage all good: ")
//                        //save msg
//
//                    }
//                } catch {
//                    print("Sending Image error: \(error)")
//                }
//            }
//        }
//
//        task.resume()
//
//    }
    
    func sendVoice(voice: Data, chatId: Int, voiceName: String) {
        
        print("sendVoice voice")
        
        let newMsg = Message(context: context)
        newMsg.chatId = Int64(chatId)
        newMsg.msgType = 2
        newMsg.deliveredTime = Date.distantFuture
        newMsg.delivered = false
        newMsg.from = Int64(KeychainWrapper.standard.integer(forKey: "userId")!)
        newMsg.id = UUID(uuidString: UUID().uuidString)
        newMsg.message = voiceName
        
        
        
        
        var request = MultipartFormDataRequest(url: URL(string: Constants.ImageURL + "/upload")!)
//        request.addDataField(named: "images", data: photos[0], mimeType: "img/jpeg")
        
        request.addDataField(named: "voice", data: voice, mimeType: "audio/mp4", imgId: "")

        request.addTextField(named: "chatId", value: String(chatId))
        request.addTextField(named: "msgId", value: newMsg.id!.uuidString)

        let fileUrl = Constants.VoiceDir.appendingPathComponent(voiceName + ".m4a")
        
        
        do {
            try voice.write(to: fileUrl)
        } catch{
            print("Simething wront with voice file: \(error)")
        }
        
        self.messageDelegate?.newMessage(msg: newMsg, del: false)
        
        let task = URLSession.shared.dataTask(with: request.asURLRequest()) { data, response, error in
            if error != nil {
                print("ChatManager: sendVoice - sending voice went wrong: \(error)")
                return
            }
            if let safeData = data {
                do {
                    print("Chatmanager: got data back: ")
                    let responseDto = try self.decoder.decode(MultiResponse.self, from: safeData)
                    if responseDto.errorCode == "200" {
                        print("Voice sent all good all good: ")
                        //save msg
                        newMsg.delivered = true
                        newMsg.deliveredTime = responseDto.data?.deliveredTime
                        self.saveMsg(chatId: newMsg.chatId)
                        self.messageDelegate?.updateMsg(msg: newMsg)
                    }
                } catch {
                    print("Sending Image error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    
    func deleteVoice(voiceId: String) {
        
    }
    
    
    
//    func sendFiles() {
//        let parameters = [
//          [
//            "key": "chatId",
//            "value": "4",
//            "type": "text"
//          ],
//          [
//            "key": "images",
//            "src": "/Users/adam/Documents/Book1.xlsx",
//            "type": "file"
//          ],
//          [
//            "key": "images",
//            "src": "/Users/adam/Documents/collegereport.pdf",
//            "type": "file"
//          ]] as [[String: Any]]
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var body = ""
//        var error: Error? = nil
//        for param in parameters {
//          if param["disabled"] != nil { continue }
//          let paramName = param["key"]!
//          body += "--\(boundary)\r\n"
//          body += "Content-Disposition:form-data; name=\"\(paramName)\""
//          if param["contentType"] != nil {
//            body += "\r\nContent-Type: \(param["contentType"] as! String)"
//          }
//          let paramType = param["type"] as! String
//          if paramType == "text" {
//            let paramValue = param["value"] as! String
//            body += "\r\n\r\n\(paramValue)\r\n"
//          } else {
//            let paramSrc = param["src"] as! String
//            let fileData = try NSData(contentsOfFile: paramSrc, options: []) as Data
//            let fileContent = String(data: fileData, encoding: .utf8)!
//            body += "; filename=\"\(paramSrc)\"\r\n"
//              + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//          }
//        }
//        body += "--\(boundary)--\r\n";
//        let postData = body.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: "http://192.168.4.34:89/image/upload")!,timeoutInterval: Double.infinity)
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//          guard let data = data else {
//            print(String(describing: error))
//            return
//          }
//          print(String(data: data, encoding: .utf8)!)
//        }
//
//        task.resume()
//    }
    
    
}






