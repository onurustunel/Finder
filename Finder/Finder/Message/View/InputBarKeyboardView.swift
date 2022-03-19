//
//  InputBarKeyboardView.swift
//  Finder
//
//  Created by Onur Ustunel on 17.03.2022.
//

import UIKit
class InputBarKeyboardView: UIView {
    let messageTextView = UITextView()
    let sendButton = UIButton(title: " Send ", titleColor: .white, titleFont: .systemFont(ofSize: 14, weight: .bold), background: .clear)
    let placeholderLabel = UILabel(text: "Message...", font: .systemFont(ofSize: 14), textColor: .lightGray)
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        backgroundColor = #colorLiteral(red: 0.1178900227, green: 0.1414454281, blue: 0.1584983468, alpha: 1)
        autoresizingMask = .flexibleHeight
        makeShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -9), color: .lightGray)
        inputView()
    }
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    @objc fileprivate func textViewChange() {
        placeholderLabel.isHidden = messageTextView.text.count != 0
        sendButton.isEnabled = messageTextView.text.count != 0
    }
    private func inputView() {
        sendButton.isEnabled = false
        messageTextView.font = .systemFont(ofSize: 14)
        messageTextView.isScrollEnabled = false
        messageTextView.layer.cornerRadius = 16
        messageTextView.backgroundColor = #colorLiteral(red: 0.1995537281, green: 0.2197108269, blue: 0.2333216071, alpha: 1)
        createHorizontalStackView(messageTextView, sendButton.sizing(.init(width: 65, height: 50)),
                                  alignment: .center).withMarging(.init(top: 0, left: 15, bottom: 0, right: 15))
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: sendButton.leadingAnchor,
                                padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
