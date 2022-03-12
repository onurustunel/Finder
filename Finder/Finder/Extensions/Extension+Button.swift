//
//  Extension+Button.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
extension UIButton {
    convenience init(title: String, titleColor: UIColor, titleFont: UIFont = .systemFont(ofSize: 15),
                     background: UIColor = .clear, target: Any? = nil, action: Selector? = nil) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = titleFont
        self.backgroundColor = background
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    convenience init(image: UIImage, tintColor: UIColor? = nil, target: Any? = nil, action: Selector? = nil) {
        self.init(type: .system)
        if tintColor == nil {
            setImage(image, for: .normal)
        } else {
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
}
