//
//  UserListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol UserListPresenterInterface: class {
    var delegate: UserListPresenterDelegate? { get set }
}

protocol UserListPresenterDelegate: class {
    
}

final class UserListPresenter: UserListPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: UserListPresenterDelegate?
    
    private let networkManager: NetworkManager?
    
    // MARK: - Constructor
    
    init() {
        networkManager = .init()
        setup()
    }
    
    // MARN: - Methods
    
    private func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.networkManager?.registerNewUser(User(deviceId: "DeviceId-123123124qrda", displayName: "Test device"))
        }
        
    }
    
}
