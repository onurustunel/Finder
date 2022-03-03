//
//  ProfileDetailBottomView.swift
//  Finder
//
//  Created by Onur Ustunel on 4.03.2022.
//

import UIKit

class ProfileDetailBottomView: UIStackView {
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let superlikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "superLike")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        let bottomButtom = [likeButton, superlikeButton, closeButton]
        bottomButtom.forEach { (bottom) in
            addArrangedSubview(bottom)
        }
    }
    required init(coder: NSCoder) {
        fatalError()
    }
}
