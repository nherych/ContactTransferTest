//
//  PhonebookListPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol PhonebookListPresenterInterface: class {
    var delegate: PhonebookListPresenterDelegate? { get set }
}

protocol PhonebookListPresenterDelegate: class {
    
}

final class PhonebookListPresenter: PhonebookListPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: PhonebookListPresenterDelegate?
    
    private let phonebook = PhonebookManager()
    
    // MARK: - Constructor
    
    init() {
        setup()
    }
    
    // MARN: - Methods
    
    private func setup() {
        
        phonebook.fetchContacts()
    }
    
}
