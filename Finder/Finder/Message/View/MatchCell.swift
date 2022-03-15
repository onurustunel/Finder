//
//  MatchCell.swift
//  Finder
//
//  Created by Onur Ustunel on 13.03.2022.
//

import UIKit
class MatchCell: ListCell<Matching> {
    let profileImage = UIImageView(image: UIImage(named: "gencay"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Gencay", font: .systemFont(ofSize: 15, weight: .bold),
                                textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    override var data: Matching! {
        didSet {
            updateUI(data: data)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        profileImage.clipsToBounds = true
        profileImage.sizing(.init(width: 100, height: 100))
        profileImage.layer.cornerRadius = 50
        createStackView(createStackView(profileImage, alignment: .center), usernameLabel)
    }
    fileprivate func updateUI(data: Matching) {
        usernameLabel.text = data.username
        guard let url = URL(string: data.profileImageUrl) else { return }
        profileImage.sd_setImage(with: url)
    }
}
