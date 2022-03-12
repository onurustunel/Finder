//
//  Extension+UILabel.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
extension UILabel {
    convenience init(text: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 15), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines        
    }
}
