//
//  UserSessionVC.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

final class UserSessionVC: UIViewController {

    // MARK: - Properties
    
    private let presenter: UserSessionPresenterInterface?
    
    // MARK: - Contructor
    
    init(presenter: UserSessionPresenterInterface) {
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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    


}

// MARK: - Configuration
extension UserSessionVC {
    private func configure() {
        
    }
}

// MARK: - UserSessionPresenterDelegate
extension UserSessionVC: UserSessionPresenterDelegate {
    
}
