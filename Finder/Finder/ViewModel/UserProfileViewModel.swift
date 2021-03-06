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
    let userID: String
    internal init(attributedString: NSAttributedString, imageNames: [String], infoLocation: NSTextAlignment, userID: String) {
        self.attributedString = attributedString
        self.imageNames = imageNames
        self.infoLocation = infoLocation
        self.userID = userID
    }
    private var imageIndex = 0 {
        didSet {
            updateImage()
        }
    }
    var imageIndexObserver : ( (Int, String?) -> () )?
    func showNextImage() {
        imageIndex = imageIndex + 1 >= imageNames.count ? 0 : imageIndex + 1
    }
    func showPreviousPhoto() {
        imageIndex = imageIndex - 1 < 0 ? imageNames.count - 1 : imageIndex - 1
    }
    private func updateImage() {
        if imageNames.isEmpty { return }
        let imageUrl = imageNames[imageIndex]   
        imageIndexObserver?(imageIndex, imageUrl)
    }
}

protocol UserProfileViewModelCreator {
    func profileViewModelCreator() -> UserProfileViewModel
}
