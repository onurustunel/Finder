//
//  RoundedImageView.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
open class RoundedImageView: UIImageView {
    public init(width: CGFloat, image: UIImage? = nil) {
        super.init(image : image)
        contentMode = .scaleAspectFill
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        heightAnchor.constraint(equalToConstant: width).isActive = true
        clipsToBounds = true
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
