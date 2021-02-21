//
//  PhonebookListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol PhonebookListPresenterInterface: PhonebookUserInvitePresenterInterface {
    var delegate: PhonebookListPresenterDelegate? { get set }
    
    var numberOfContacts: Int { get }
    func contactAtIndex(_ index: Int) -> Contact
    
    func didTapOnUserList()
}

protocol PhonebookUserInvitePresenterInterface: class {
    func acceptInvite(_ invite: Invite)
    func declineInvite(_ invite: Invite)
}

protocol PhonebookUserInvitePresenterDelegate: class {
    func didReceiveInvite(_ invite: Invite)
}

protocol PhonebookListPresenterDelegate: PhonebookUserInvitePresenterDelegate {
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
    
    func acceptInvite(_ invite: Invite) {
        guard let myName = networkManager.currentUser?.displayName else { return }
        networkManager.sendInviteAnswer(invite.accept(myName: myName))
    }
    
    func declineInvite(_ invite: Invite) {
        guard let myName = networkManager.currentUser?.displayName else { return }
        networkManager.sendInviteAnswer(invite.decline(myName: myName))
    }
    
    private func setup() {
        phonebook.fetchContacts { [weak self] contacts in
            self?.contacts = contacts
            print(contacts)
            self?.delegate?.shouldUpdateContactList()
        }
        
        networkManager.didReceiveInvite { [weak self] invite in
            print(invite)
            self?.delegate?.didReceiveInvite(invite)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                guard let myName = self?.networkManager.currentUser?.displayName else { return }
//                self?.networkManager.sendInviteAnswer(invite.accept(myName: myName))
//            }
        }
        
        networkManager.didReceiveInviteAnswer { invite in
            print("==== ANSWER ====")
            print(invite)
        }
    }
    
}


