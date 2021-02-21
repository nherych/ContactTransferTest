//
//  ContactTransferPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol ContactTransferPresenterInterface: class {
    var delegate: ContactTransferPresenterDelegate? { get set }
}

protocol ContactTransferPresenterDelegate: class {
    
}

final class ContactTransferPresenter: ContactTransferPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: ContactTransferPresenterDelegate?
    
    // MARK: - Constructor
    
    init() {
        setup()
    }
    
    // MARN: - Methods
    
    private func setup() {
        
    }
    
}
