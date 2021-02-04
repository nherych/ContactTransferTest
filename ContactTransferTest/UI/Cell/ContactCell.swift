//
//  ContactCell.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 03.02.2021.
//

import UIKit

class ContactCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    //...
    
    // MARK: - Views
    
    private let photoImageView: UIImageView = .make()
    
    private lazy var textContainer: UIStackView = .makeStack(
        axis: .vertical,
        arrangedSubviews: [userNameLabel, phoneNumberLabel, emailAdressLabel])
    
    private let userNameLabel: UILabel = .makeSubheader(withSize: 18)
    private let phoneNumberLabel: UILabel = .makeSubheader(withSize: 16)
    private let emailAdressLabel: UILabel = .makeRegular(withSize: 16)
    
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
extension ContactCell {
    func configure() {
        setupLayout()
    }
    
    func setupLayout() {
        setupPhotoImageView()
        setupTextContainer()
        
        userNameLabel.text = "Thomas Edison"
        phoneNumberLabel.text = "+100 3434 34 556"
        emailAdressLabel.text = "thomas.edison@gmail.com"
    }
    
    private func setupPhotoImageView() {
        photoImageView.layer.setCornerRadius(width: 32)
        contentView.addSubview(photoImageView)
        photoImageView.backgroundColor = .lightGray
        photoImageView.layout {
            $0.constraint(to: contentView, by: .leading(10))
            $0.centerY.constraint(to: contentView, by: .centerY(0))
            $0.size(.height(64), .width(64))
        }
    }
    
    private func setupTextContainer() {
        contentView.addSubview(textContainer)
        textContainer.setDistribution(.equalSpacing)
        textContainer.layout {
            $0.constraint(to: contentView, by: .trailing(-10), .bottom(-10), .top(10))
            $0.leading.constraint(to: photoImageView, by: .trailing(30))
            $0.size(.height(64))//, .width(64))
        }
    }
}
