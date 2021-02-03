//
//  UserCell.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    //...
    
    // MARK: - Views
    
    private lazy var container: UIStackView = .makeStack(
        axis: .horizontal,
        arrangedSubviews: [userNameLabel, pairButton])
    
    private let userNameLabel: UILabel = .makeSubheader()
    private let pairButton: UIButton = .make(title: "Pair")
    
    // MARK: - Constructor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Methods
    
}


// MARK: - Configuration
extension UserCell {
    func configure() {
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addSubview(container)
        container.layout {
            $0.constraint(to: contentView)
        }
        
        userNameLabel.text = "Teset wests t"
        pairButton.widthAnchor.constraint(equalToConstant: 80).activate()
    }
}
