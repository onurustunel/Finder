//
//  ImageViewAspectFill.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
class ImageViewAspectFill: UIImageView {
    convenience init() {
        self.init(image: nil)
        contentMode = .scaleToFill
        clipsToBounds = true
    }
}
