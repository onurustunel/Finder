//
//  TextFieldIntend.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
class TextFieldIntend: UITextField {
    let padding: CGFloat
    public init(placeHolder: String? = nil, padding: CGFloat = 0, cornerRadius: CGFloat = 0,
                keyboardType: UIKeyboardType = .default, backgroundColor: UIColor = UIColor.clear, isSecureText: Bool = false) {
        self.padding = padding
        super.init(frame: .zero)
        self.placeholder = placeHolder
        layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureText
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
}
