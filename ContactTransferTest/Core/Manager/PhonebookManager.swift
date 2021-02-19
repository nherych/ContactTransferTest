//
//  PhonebookManager.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 04.02.2021.
//

import Foundation
import Contacts

protocol PhonebookFetchable {
    func fetchContacts(_ contactsHandler: @escaping ([Contact])->Void)
}

class PhonebookManager {
    
    // MARK: - Properties
    
    private let store: CNContactStore
    
    //data
    private var contacts: [Contact] = []
    
    private let keysToFetch = [
        CNContactGivenNameKey, CNContactFamilyNameKey,
        CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
    
    // MARK: - Contructor
    
    init() {
        self.store = CNContactStore()
    }
    
    // MARK: - Methods
    
    func fetchContacts(_ contactsHandler: @escaping ([Contact]) -> Void) {
        do {
            store.requestAccess(for: .contacts) { [weak self] isAuthorize, error in
                guard isAuthorize, let keys = self?.keysToFetch else { return }
                try? self?.store.enumerateContacts(
                    with: CNContactFetchRequest(keysToFetch: keys),
                    usingBlock: { (cncontact, point) in
                        let contact = Contact(contact: cncontact)
                        self?.contacts.append(contact)
                        if let contacts = self?.contacts {
                            contactsHandler(contacts)
                        }
//                        print("Fetched contacts: \(contact)")
                })
            }
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
        }
    }
}

extension PhonebookManager: PhonebookFetchable {
//    func fetchContacts() {
//        do {
//            store.requestAccess(for: .contacts) { isAuthorize, error in
//                guard isAuthorize else { return }
//                try? store.enumerateContacts(
//                    with: CNContactFetchRequest(keysToFetch: keysToFetch),
//                    usingBlock: { (cncontact, point) in
//                        let contact = Contact(contact: cncontact)
//                        print("Fetched contacts: \(contact)")
//                })
//            }
//        } catch {
//            print("Failed to fetch contact, error: \(error)")
//            // Handle the error
//        }
//    }
}



struct Contact {
    let name: String
    let surname: String
    let phoneNumber: String
    let email: String
}

extension Contact {
    init(contact: CNContact) {
        self.name = contact.givenName
        self.surname = contact.familyName
        self.phoneNumber = (contact.phoneNumbers.first?.value)?.stringValue ?? ""
        self.email = (contact.emailAddresses.first?.value as? String) ?? ""
    }
    
    var fullName: String {
        return name + " " + surname
    }
}
