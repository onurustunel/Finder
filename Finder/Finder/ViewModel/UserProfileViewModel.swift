//
//  UserProfileViewModel.swift
//  Finder
//
//  Created by Onur Ustunel on 30.11.2021.
//

import UIKit

class UserProfileViewModel {
    let attributedString: NSAttributedString
    let imageNames: [String]
    let infoLocation: NSTextAlignment
    internal init(attributedString: NSAttributedString, imageNames: [String], infoLocation: NSTextAlignment) {
        self.attributedString = attributedString
        self.imageNames = imageNames
        self.infoLocation = infoLocation
    }
    private var imageIndex = 0 {
        didSet {
            updateImage()
        }
    }
    var imageIndexObserver : ( (Int, UIImage) -> () )?
    func showNextImage() {
        imageIndex = imageIndex + 1 >= imageNames.count ? 0 : imageIndex + 1
    }
    func showPreviousPhoto() {
        imageIndex = imageIndex - 1 < 0 ? imageNames.count - 1 : imageIndex - 1
    }
    private func updateImage() {
        let imageName = imageNames[imageIndex]
        let imageProfile = UIImage(named: imageName)
        imageIndexObserver?(imageIndex, imageProfile ?? UIImage())
    }
}

protocol UserProfileViewModelCreator {
    func profileViewModelCreator() -> UserProfileViewModel
}
