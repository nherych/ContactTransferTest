//
//  UserSessionPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol UserSessionPresenterInterface: class {
    var delegate: UserSessionPresenterDelegate? { get set }
}

protocol UserSessionPresenterDelegate: class {
    
}

final class UserSessionPresenter: UserSessionPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: UserSessionPresenterDelegate?
    
    // MARK: - Constructor
    
    init() {
        setup()
    }
    
    // MARN: - Methods
    
    private func setup() {
        
    }
    
}
