//
//  UserListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol UserListPresenterInterface: class {
    var delegate: UserListPresenterDelegate? { get set }
    
    var numberOfUsers: Int { get }
    func userAtIndex(_ index: Int) -> User
}

protocol UserListPresenterDelegate: class {
    func shouldReloadUserList()
}

final class UserListPresenter: UserListPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: UserListPresenterDelegate?
    
    private let networkManager: NetworkManager?
    
    //data
    private var users: [User] = []
    
    
    // MARK: - Constructor
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        setup()
    }
    
    // MARK: - Interface
    
    var numberOfUsers: Int {
        users.count
    }
    
    func userAtIndex(_ index: Int) -> User {
        users[index]
    }
    
    // MARK: - Methods
    
    private func setup() {
        subscribeUsersUpdate()
    }
    
}

// MARK: - Fetching users
extension UserListPresenter {
    private func subscribeUsersUpdate() {
        networkManager?.fetchUsers({ [weak self] users in
            self?.users = users
            self?.delegate?.shouldReloadUserList()
        })
    }
}
