//
//  MessageNavBar.swift
//  Finder
//
//  Created by Onur Ustunel on 13.03.2022.
//

import UIKit
class MessageNavBar: UIView {
    let profileImage = RoundedImageView(width: 60, image: UIImage())
    let usernameLabel = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .bold), textColor: .white, textAlignment: .center)
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.8616023064, green: 0.3684691787, blue: 0.4407086372, alpha: 1))
    let reportButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.8616023064, green: 0.3684691787, blue: 0.4407086372, alpha: 1))
    
    fileprivate var matching: Matching 
     init(matching: Matching) {
        self.matching = matching
        super.init(frame: .zero)
        updateUI(matching: matching)
        backgroundColor = ConstantColor.darkBackgroundColor
        makeShadow(opacity: 0.15, radius: 10, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        configureNavigationBar()
    }
    
    fileprivate func updateUI(matching: Matching) {
        guard let url = URL(string: matching.profileImageUrl) else { return }
        profileImage.sd_setImage(with: url)
        usernameLabel.text = matching.username
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    fileprivate func configureNavigationBar() {
        let centerStackView = createHorizontalStackView(createStackView(profileImage, usernameLabel, spacing: 10, alignment: .center), alignment:.center)
        createHorizontalStackView(backButton, centerStackView, reportButton).withMarging(.init(top: 0, left: 15, bottom: 0, right: 15))
    }
}
