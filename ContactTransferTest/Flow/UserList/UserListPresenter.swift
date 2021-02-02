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
    
    // MARK: - Constructor
    
    init() {
        setup()
    }
    
    // MARN: - Methods
    
    private func setup() {
        
    }
    
}
