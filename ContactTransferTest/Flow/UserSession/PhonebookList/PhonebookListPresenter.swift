//
//  PhonebookListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol PhonebookListPresenterInterface: class {
    var delegate: PhonebookListPresenterDelegate? { get set }
    
    var numberOfContacts: Int { get }
    func contactAtIndex(_ index: Int) -> Contact
    
    func didTapOnUserList()
}

protocol PhonebookListPresenterDelegate: class {
    func shouldUpdateContactList()
    func shouldOpenUserListWith(presenter: UserListPresenterInterface)
}

final class PhonebookListPresenter: PhonebookListPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: PhonebookListPresenterDelegate?
    
    private let phonebook = PhonebookManager()
    private let networkManager: NetworkManager
    
    //data
    private var contacts: [Contact] = []
    
    // MARK: - Constructor
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        setup()
    }
    
    // MARK: - Interface
    
    var numberOfContacts: Int {
        contacts.count
    }
    
    func contactAtIndex(_ index: Int) -> Contact {
        contacts[index]
    }
    
    func didTapOnUserList() {
        let presenter = UserListPresenter(networkManager: networkManager)
        delegate?.shouldOpenUserListWith(presenter: presenter)
    }
    
    // MARN: - Methods
    
    private func setup() {
        phonebook.fetchContacts { [weak self] contacts in
            self?.contacts = contacts
            print(contacts)
            self?.delegate?.shouldUpdateContactList()
        }
    }
    
}
