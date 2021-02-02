//
//  StartPresenter.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import Foundation

protocol StartPresenterInterface: class {
    var delegate: StartPresenterDelegate? { get set }
}

protocol StartPresenterDelegate: class {
    
}

final class StartPresenter: StartPresenterInterface {
    
    // MARK: - Properties
    
    weak var delegate: StartPresenterDelegate?
    
    // MARK: - Constructor
    
    init() {
        setup()
    }
    
    // MARN: - Methods
    
    private func setup() {
        
    }
    
}
