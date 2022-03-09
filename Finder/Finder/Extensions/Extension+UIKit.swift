//
//  Extension+UIKit.swift
//  Finder
//
//  Created by Onur Ustunel on 13.02.2022.
//

import UIKit
extension UIButton {
    static func buttonMaker(title: String, selector: Selector, controller: UIViewController) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 0.05)
        button.setTitle("\(title)", for: .normal)
        button.addTarget(controller, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}
