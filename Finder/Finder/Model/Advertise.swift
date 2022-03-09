//
//  Advertise.swift
//  Finder
//
//  Created by Onur Ustunel on 30.11.2021.
//

import UIKit
struct Advertise: UserProfileViewModelCreator {
    let title: String
    let brandName: String
    let imageName: String
    let infoLocation: NSTextAlignment
    func profileViewModelCreator() -> UserProfileViewModel {
        let attributedText = NSMutableAttributedString(string: "\(title),", attributes: [.font: AppFont.appFontStyle(size: 30, style: .bold)])
        attributedText.append(NSAttributedString(string: "\n \(brandName)", attributes: [.font: AppFont.appFontStyle(size: 24, style: .bold)]))
        return UserProfileViewModel(attributedString: attributedText, imageNames: [imageName], infoLocation: .center, userID: "")
    }
}
