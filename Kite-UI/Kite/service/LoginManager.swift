//
//  LoginManager.swift
//  Kite
//
//  Created by Adam on 7/26/22.
//

import Foundation
import CoreImage
import CoreData
import UIKit

protocol LoginDelegate: AnyObject {
    func didUsernameExist(status: Bool)
    func didEmailExist(status: Bool)
    func didVer(code: Int)
    func didLogin(email: String)
    func didCreateUser(code: Int)
    func didErrorHappen(msg: String)
}
let url = Constants.URL + ":80/api"
struct LoginManager {
    let loginURL = url + "/dologin"
    let signupURL = url + "/create"
    let loginVerURL = url + "verLogin"
    let signupVerURL = url + "newVer"
    
    static let shared = LoginManager()
    private init() {}
    
    weak var delegate: LoginDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func checkUsername(username: String) {
        print("LoginManager: checkUsername")
        if let url = URL(string: url + "/findUsername") {
            var request = URLRequest(url: url)
            let string = "{\"username\":\"\(username)\"}"
            guard let jsonData = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!) else {
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = string.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("checkUsername : error")
                    self.delegate?.didErrorHappen(msg: "Internet problem")
                    return
                }
                
                if let safeData = data {
                    print("LoginManager: checkUsername the data: \(safeData)")
                    let decoder = JSONDecoder()
                    do {
                        let responseDto = try decoder.decode(DtoResponse.self, from: safeData)
                        if responseDto.errorCode == "200" {
                            let status = try decoder.decode(CheckVO.self, from: (responseDto.data?.data(using: .utf8))!)
                            self.delegate?.didUsernameExist(status: status.status)
                        } else if responseDto.errorCode == "401" {
                            self.delegate?.didErrorHappen(msg: responseDto.msg)
                        } else {
                            self.delegate?.didErrorHappen(msg: "")
                        }
                    }catch {
                        self.delegate?.didErrorHappen(msg: "")
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func checkEmail(email: String) {
        if let url = URL(string: url + "/findEmail") {
            var request = URLRequest(url: url)
            let string = "{\"email\":\"\(email)\"}"
            guard let jsonData = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!) else {
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = string.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("checkEmail : error")
                    self.delegate?.didErrorHappen(msg: "Internet problem")
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let responseDto = try decoder.decode(DtoResponse.self, from: safeData)
                        if responseDto.data == nil {
                            self.delegate?.didErrorHappen(msg: "")
                        } else {
                            let status = try decoder.decode(CheckVO.self, from: responseDto.data!.data(using: .utf8)!)
                            self.delegate?.didEmailExist(status: status.status)
                        }
                    }catch {
                        self.delegate?.didErrorHappen(msg: "")
                    }
                    
                }
            }
        }
    }
    
    
    func createUser(user: CreateUserVO) {
        print("LoginManager: creatUser")
        if let url = URL(string: url + "/create") {
            var request = URLRequest(url: url)
            guard let jsonData = try? JSONEncoder().encode(user) else {
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("createUser : error")
                    self.delegate?.didErrorHappen(msg: "Internet problem")
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let responseDto = try decoder.decode(DtoResponse.self, from: safeData)
                        print("in createUser msg: \(responseDto.msg)")
                        if responseDto.errorCode == "200" {
                            self.delegate?.didCreateUser(code: 0)
                        } else if responseDto.errorCode == "401" {
                            print("LoginManager: createUser responseDto msg: \(responseDto.msg)")
                            if responseDto.msg == "email already exists" {
                                self.delegate?.didCreateUser(code: 2)
                            } else {
                                self.delegate?.didCreateUser(code: 1)
                            }
                        } else {
                            self.delegate?.didErrorHappen(msg: "")
                        }
                    }catch {
                        self.delegate?.didErrorHappen(msg: "")
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func doLogin(user: LoginUserVO) {
        if let url = URL(string: url + "/dologin") {
            var request = URLRequest(url: url)
            guard let jsonData = try? JSONEncoder().encode(user) else {
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("doLogin : error")
                    self.delegate?.didErrorHappen(msg: "Internet problem")
                    return
                }
                
                if let safeData = data {
                    print("doLogin safedata: \(safeData)")
                    let decoder = JSONDecoder()
                    do {
                        let responseDto = try decoder.decode(DtoResponse.self, from: safeData)
                        if responseDto.errorCode == "200" {
                            let status = try decoder.decode(LoginEmail.self, from: (responseDto.data?.data(using: .utf8))!)
                            self.delegate?.didLogin(email: status.email)
                        } else {
                            print("doLogin errorCode: \(responseDto.errorCode)")
                            self.delegate?.didErrorHappen(msg: "")
                        }
                    }catch {
                        print("doLogin escetioin")
                        self.delegate?.didErrorHappen(msg: "")
                    }
                    
                }
            }
            task.resume()
        }
    }
                                                  
    
    func Verify(verCode: VerEmailVO, newVer: Bool) {
        print("in Verify")
        let api = newVer ? "/newVer" : "/verLogin"
        if let url = URL(string: url + api) {
            var request = URLRequest(url: url)
            guard let jsonData = try? JSONEncoder().encode(verCode) else {
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("verify : error: \(error)")
                    self.delegate?.didErrorHappen(msg: "")
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let responseDto = try decoder.decode(DtoResponse.self, from: safeData)
                        if responseDto.errorCode == "200" {
                            print("Verify token: \(responseDto.data!)")
                            let token = try decoder.decode(TokenVO.self, from: (responseDto.data?.data(using: .utf8))!)
                            KeychainWrapper.standard.set(token.token, forKey: "token")
                            if KeychainWrapper.standard.integer(forKey: "userId") ?? -1 != token.userId {
                                
                            }
                            KeychainWrapper.standard.set(Int(token.userId), forKey: "userId")
                            let df = DateFormatter()
                            df.dateFormat = "MM-dd-yyyy"
                            KeychainWrapper.standard.set(df.string(from: Date()), forKey: "lastLoginDate")
                            self.delegate?.didVer(code: 0)
                        } else if responseDto.errorCode == "401"{
                            self.delegate?.didVer(code: 1)
                        } else {
                            self.delegate?.didErrorHappen(msg: "")
                        }
                    }catch {
                        print("Verify something went wrong: \(error)")
                        self.delegate?.didErrorHappen(msg: "")
                    }
                    
                }
            }
            task.resume()
        }
    }

    func deleteAllData() {
        print("LoginManager: deleteAllData start")
        let requestChatRoom: NSFetchRequest<NSFetchRequestResult> = ChatRoom.fetchRequest()
        let deleteChatRoomRequest = NSBatchDeleteRequest(fetchRequest: requestChatRoom)
        let requestMsg: NSFetchRequest<NSFetchRequestResult> = Message.fetchRequest()
        let deleteMsgRequest = NSBatchDeleteRequest(fetchRequest: requestMsg)
        do {
            try? context.execute(deleteMsgRequest)
            try? context.execute(deleteChatRoomRequest)
        } catch {
            print("LoginManager delteteAllData error: \(error)")
        }
        print("LoginManager: deleteAllData end")
    }
    
}
