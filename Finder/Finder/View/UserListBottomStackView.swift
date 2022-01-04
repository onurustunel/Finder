//
//  UserListBottomStackView.swift
//  Finder
//
//  Created by Onur Ustunel on 25.11.2021.
//

import UIKit

class UserListBottomStackView: UIStackView {
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let superlikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "superLike")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let boostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "boost")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        let bottomButtom = [refreshButton, closeButton, superlikeButton, likeButton, boostButton]
        bottomButtom.forEach { (bottom) in
            addArrangedSubview(bottom)
        }
    }
    required init(coder: NSCoder) {
        fatalError()
    }

}
