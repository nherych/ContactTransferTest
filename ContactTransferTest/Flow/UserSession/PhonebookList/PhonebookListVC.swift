//
//  PhonebookListVC.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

final class PhonebookListVC: UIViewController {

    // MARK: - Properties
    
    private let presenter: PhonebookListPresenterInterface?
    
    // MARK: - Contructor
    
    init(presenter: PhonebookListPresenterInterface) {
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
extension PhonebookListVC {
    private func configure() {
        
    }
}

// MARK: - PhonebookListPresenterDelegate
extension PhonebookListVC: PhonebookListPresenterDelegate {
    
}
