//
//  ConversationCell.swift
//  Finder
//
//  Created by Onur Ustunel on 18.03.2022.
//

import UIKit

class ConversationCell: ListCell<LastConversation> {
    let profileImage = UIImageView(image: UIImage(), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 17), textColor: UIColor(white: 1, alpha: 0.8))
    let messageLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .gray, numberOfLines: 2)
    override var data: LastConversation! {
        didSet {
            updateData(data: data)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        usernameLabel.text = nil
        messageLabel.text = nil
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    internal override func configureUI() {
        super.configureUI()
        createHorizontalStackView(profileImage.sizing(.init(width: 60, height: 60)),
                                  createStackView(usernameLabel, messageLabel, spacing: 5), spacing: 20, alignment: .center)
                                  .padLeft(20).padRight(20)
        profileImage.layer.cornerRadius = 30
        addSeperator(leadingAnchor: usernameLabel.leadingAnchor)
    }
    func updateData(data: LastConversation) {
        usernameLabel.text = data.username
        messageLabel.text = data.message
        profileImage.sd_setImage(with: URL(string: data.imageUrl))
    }
}
