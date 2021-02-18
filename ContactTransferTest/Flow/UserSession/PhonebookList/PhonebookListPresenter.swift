//
//  PhonebookListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol PhonebookListPresenterInterface: class {
    var delegate: PhonebookListPresenterDelegate? { get set }
    
    func didTapOnUserList()
}

protocol PhonebookListPresenterDelegate: class {
    func shouldOpenUserListWith(presenter: UserListPresenterInterface)
}

final class PhonebookListPresenter: PhonebookListPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: PhonebookListPresenterDelegate?
    
    private let phonebook = PhonebookManager()
    private let networkManager: NetworkManager
    
    // MARK: - Constructor
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        setup()
    }
    
    // MARK: - Interface
    
    func didTapOnUserList() {
        let presenter = UserListPresenter(networkManager: networkManager)
        delegate?.shouldOpenUserListWith(presenter: presenter)
    }
    
    // MARN: - Methods
    
    private func setup() {
        
        phonebook.fetchContacts()
        networkManager.fetchUsers { users in
            print(users)
        }
    }
    
}
