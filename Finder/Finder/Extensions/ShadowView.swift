//
//  ShadowView.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
extension UIView {
    func makeShadow(opacity: Float = 0, radius: CGFloat, offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    convenience init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}
