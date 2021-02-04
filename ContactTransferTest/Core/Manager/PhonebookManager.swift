//
//  PhonebookManager.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 04.02.2021.
//

import Foundation
import Contacts

protocol PhonebookFetchable {
    func fetchContacts()
}

class PhonebookManager {
    
    // MARK: - Properties
    
    private let store: CNContactStore
    
    
    // MARK: - Contructor
    
    init() {
        self.store = CNContactStore()
    }
    
    // MARK: - Methods
    
    
}

extension PhonebookManager: PhonebookFetchable {
    func fetchContacts() {
        let store = CNContactStore()
        
        do {
//            let predicate = CNContact.pre
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
//            let predicate = CNContact.predicateForContacts(matchingName: "Appleseed")
            
            store.requestAccess(for: .contacts) { isAuthorize, error in
                guard isAuthorize else { return }
                try? store.enumerateContacts(
                    with: CNContactFetchRequest(keysToFetch: keysToFetch),
                    usingBlock: { (contact, point) in
                        print("Fetched contacts: \(contact)")
                })
            }
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
        }
    }
}
