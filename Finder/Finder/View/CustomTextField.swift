//
//  CustomTextField.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit

class CustomTextField: UITextField {
    let padding: CGFloat
    var seperatorView: UIView = {
       let view = UIView()
        view.backgroundColor = ConstantColor.white
        return view
    }()
    init(padding: CGFloat, addSeperator: Bool = true) {
        self.padding = padding
        super.init(frame: .zero)
        configureCustomTextField()
        if addSeperator { self.addSeperatorView() }
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureCustomTextField() {
        backgroundColor = .clear
        textColor = ConstantColor.white
    }
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 42)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    private func addSeperatorView() {
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
}
