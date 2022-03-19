//
//  MessageCell.swift
//  Finder
//
//  Created by Onur Ustunel on 17.03.2022.
//

import UIKit

class MessageCell: ListCell<Message> {
    var messageConstraint: AnchorConstraints!
    let messageContainer = UIView(backgroundColor: #colorLiteral(red: 0.6980509162, green: 0.8613415956, blue: 0.5325160027, alpha: 1))
    let messageTextView: UITextView = {
       let textview = UITextView()
        textview.font = .systemFont(ofSize: 19)
        textview.backgroundColor = .clear
        textview.isEditable = false
        textview.isScrollEnabled = false
        return textview
    }()
    override var data: Message! {
        didSet {
            messageTextView.text = data.message
            if data.senderMe {
                messageConstraint.trailing?.isActive = true
                messageConstraint.leading?.isActive = false
                messageContainer.backgroundColor = #colorLiteral(red: 0.1480444372, green: 0.3811130822, blue: 0.385748744, alpha: 1)
                messageTextView.textColor = .white                
            } else {
                messageConstraint.trailing?.isActive = false
                messageConstraint.leading?.isActive = true
                messageContainer.backgroundColor = #colorLiteral(red: 0.1499120593, green: 0.1765852571, blue: 0.1936545372, alpha: 1)
                messageTextView.textColor = .white
            }
        }
    }
    override func configureUI() {
        super.configureUI()
        addSubview(messageContainer)
        messageConstraint = messageContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 20, bottom: 4, right: 20))
        messageContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 280).isActive = true
        messageContainer.layer.cornerRadius = 15
        messageContainer.addSubview(messageTextView)
        messageTextView.fillSuperView(padding: .init(top: 5, left: 10, bottom: 10, right: 5))
    }    
}
