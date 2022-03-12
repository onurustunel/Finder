//
//  Extension+UITextView.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
extension UITextView {
    convenience init(text: String?, font: UIFont? = UIFont.systemFont(ofSize: 15), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}
