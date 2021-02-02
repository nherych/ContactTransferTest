//
//  UserListVC.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

final class UserListVC: UIViewController {

    // MARK: - Properties
    
    private let presenter: UserListPresenterInterface?
    
    // MARK: - Contructor
    
    init(presenter: UserListPresenterInterface) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.delegate = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Methods
    
    


}

// MARK: - Configuration
extension UserListVC {
    private func configure() {
        
    }
}

// MARK: - UserListPresenterDelegate
extension UserListVC: UserListPresenterDelegate {
    
}
