//
//  UserListTopStackView.swift
//  Finder
//
//  Created by Onur Ustunel on 25.11.2021.
//

import UIKit

class UserListTopStackView: UIStackView {
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let logoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "flame")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "message")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        let bottomButtom = [profileButton, logoButton, messageButton]
        bottomButtom.forEach { (bottom) in
            addArrangedSubview(bottom)
        }
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
    }
    required init(coder: NSCoder) {
        fatalError()
    }
}
