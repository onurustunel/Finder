//
//  User.swift
//  Finder
//
//  Created by Onur Ustunel on 26.11.2021.
//

import Foundation
struct User: UserProfileViewModelCreator {
    let username: String
    let occupation: String
    let age: Int
    let imageNames: [String]
    func profileViewModelCreator() -> UserProfileViewModel {
        let attributedText = NSMutableAttributedString(string: "\(username),", attributes: [.font: AppFont.appFontStyle(size: 22, style: .bold)])
        attributedText.append(NSAttributedString(string: " \(age)", attributes: [.font: AppFont.appFontStyle(size: 18, style: .bold)]))
        attributedText.append(NSAttributedString(string: "\n\(occupation)", attributes: [.font: AppFont.appFontStyle(size: 18, style: .normal)]))
        return UserProfileViewModel(attributedString: attributedText, imageNames: imageNames, infoLocation: .left)
    }
}
