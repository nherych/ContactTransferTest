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
    func didReceiveInvite(_ handler: @escaping (Invite)->Void)
    func didReceiveInviteAnswer(_ handler: @escaping (Invite)->Void)
    func sendInviteAnswer(_ invite: Invite)
    func requestInviteFor(_ user: User)
}

class NetworkManager {
    
    // MARK: - Properties
    
    private let socketClient: StompClientLib
    private let url = URL(string: UrlPath.base.url)!
    private (set) var currentUser: User?
    
    private var fetchUserHandlerStorage: [([User])->Void] = []
    private var inviteHandlerStorage: [(Invite)->Void] = []
    private var inviteAnswerHandlerStorage: [(Invite)->Void] = []
    
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
        currentUser = user
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
    func didReceiveInvite(_ handler: @escaping (Invite)->Void) {
        inviteHandlerStorage.append(handler)
    }
    
    func didReceiveInviteAnswer(_ handler: @escaping (Invite) -> Void) {
        inviteAnswerHandlerStorage.append(handler)
    }
    
    func sendInviteAnswer(_ invite: Invite) {
        socketClient.sendJSONForDict(dict: invite.toDict, toDestination: UrlPath.sendInvite.url)
    }
    
    func requestInviteFor(_ user: User) {
        guard let currentUser = currentUser else { return }
        let invite = Invite(
            destinationDeviceId: user.deviceId,
            deviceId: currentUser.deviceId,
            displayName: currentUser.displayName,
            accepted: nil)
        socketClient.sendJSONForDict(dict: invite.toDict, toDestination: UrlPath.sendInvite.url)
    }
    
    private var currentUserReceiveInvite: String? {
        guard let uuid = currentUser?.deviceId else { return nil }
        return UrlPath.invite(uuid).url
    }
    
    private func subscribeOnReceiveInvite() {
        guard let url = currentUserReceiveInvite else { return }
        socketClient.subscribe(destination: url)
        socketClient.subscribe(destination: UrlPath.sendInvite.url)
    }
    
    private func handleReceiveInvite(_ data: AnyObject) {
        guard let invite = Invite(data: data) else { return }
        
        if invite.accepted == nil {
            inviteHandlerStorage.forEach {
                $0(invite)
            }
        } else {
            inviteAnswerHandlerStorage.forEach {
                $0(invite)
            }
        }
        
    }
    
    private func handleGetAnswerForInviteFromUsers(_ data: AnyObject) {
        guard let invite = Invite(data: data) else { return }
        guard let currentUser = currentUser,
              invite.deviceId == currentUser.deviceId, invite.accepted != nil else { return }
        
        inviteAnswerHandlerStorage.forEach {
            $0(invite)
        }
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
        case currentUserReceiveInvite ?? "":
            handleReceiveInvite(response)
        case UrlPath.sendInvite.url:
            handleGetAnswerForInviteFromUsers(response)
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




