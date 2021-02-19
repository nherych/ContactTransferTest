//
//  NetworkManager.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 04.02.2021.
//

import Foundation
import StompClientLib

enum UrlPath {
    case base
    
    // register
    case users
    case register
    
    case invite(String)
    case sendInvite
    
    var url: String {
        switch self {
        case .base:
            return "ws://test-env-2.eba-3e7rpc8d.us-east-1.elasticbeanstalk.com/ws"
        case .users:
            return "/topic/public"
        case .register:
            return "/app/register"
        case .invite(let uuid):
            return "/user/\(uuid)/invite"
        case .sendInvite:
            return "/app/invite"
        }
    }
}

protocol NetworkUserManagable {
    func registerNewUser(_ user: User)
    func fetchUsers(_ usersHandler: @escaping ([User])->Void)
}

protocol NetworkInvitable {
    func didReceiveInvite()
    func sendInviteResponse(_ response: Bool)
}

class NetworkManager {
    
    // MARK: - Properties
    
    private let socketClient: StompClientLib
    private let url = URL(string: UrlPath.base.url)!
    private let currentUserUUID = UIDevice.current.identifierForVendor?.uuidString
    
    private var fetchUserHandlerStorage: [([User])->Void] = []
    
    //data
    private var users: [User] = [] {
        didSet {
            fetchUserHandlerStorage.forEach {
                $0(users)
            }
        }
    }
    
    // MARK:  - Constructor
    
    init() {
        self.socketClient = StompClientLib()
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
    }
    
    func connect() {
        
    }
    
}

// MARK: - NetworkUserManagable
extension NetworkManager: NetworkUserManagable {
    func registerNewUser(_ user: User) {
        socketClient.sendJSONForDict(dict: user.toDict, toDestination: UrlPath.register.url)
        subscribeOnReceiveInvite()
    }
    
    func fetchUsers(_ usersHandler: @escaping ([User]) -> Void) {
        fetchUserHandlerStorage.append(usersHandler)
        usersHandler(users)
    }
    
    private func handleReceiveUpdateUser(_ data: AnyObject) {
        let users = User.parseUsers(data)
        guard !users.isEmpty else { return }
        self.users = users
    
        
    }
}

// MARK: - NetworkInvitable
extension NetworkManager: NetworkInvitable {
    func didReceiveInvite() {
        
    }
    
    func sendInviteResponse(_ response: Bool) {
        
    }
    
    var currentUserReceiveInvite: String? {
        guard let uuid = currentUserUUID else { return nil }
        return UrlPath.invite(uuid).url
    }
    
    private func subscribeOnReceiveInvite() {
        guard let url = currentUserReceiveInvite else { return }
        socketClient.subscribe(destination: url)
    }
}

extension NetworkManager: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?,
                     akaStringBody stringBody: String?, withHeader header: [String : String]?,
                     withDestination destination: String) {
        print("OnReceive", destination)
        guard let response = jsonBody else { return }
        
        switch destination {
        case UrlPath.users.url:
            handleReceiveUpdateUser(response)
        default:
            break
        }
        
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("stompClientDidDisconnect")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        socketClient.subscribe(destination: UrlPath.users.url)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("serverDidSendReceipt")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("serverDidSendError")
    }
    
    func serverDidSendPing() {
        print("serverDidSendPing")
    }
}



struct User: Codable {
    let deviceId: String
    let displayName: String
}

extension User {
    var toDict: AnyObject {
        return ["deviceId": deviceId, "displayName": displayName] as AnyObject
    }
    
    init?(data: AnyObject) {
        guard let data = data as? [String: String] else { return nil }
        if let deviceId = data["deviceId"], let displayName = data["displayName"] {
            self.deviceId = deviceId
            self.displayName = displayName
        } else {
            return nil
        }
    }
    
    static func parseUsers(_ data: AnyObject) -> [User] {
        guard let datas = data as? [AnyObject] else { return [] }
        return datas.compactMap {
            User(data: $0)
        }
    }
}
