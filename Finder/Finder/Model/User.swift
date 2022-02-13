//
//  User.swift
//  Finder
//
//  Created by Onur Ustunel on 26.11.2021.
//

import Foundation
struct User: UserProfileViewModelCreator {
    var userID: String?
    var username: String?
    var occupation: String?
    var age: Int?
//    let imageNames: [String]
    var imageUrl: String
    internal init(userData: [String : Any]) {
        self.userID = userData["userID"] as? String ?? ""
        self.username = userData["nameSurname"] as? String ?? ""
        self.occupation = ""
        self.age = userData["age"] as? Int
        self.occupation = userData["occupation"] as? String
        self.imageUrl = userData["imageUrl"] as? String ?? ""
    }  
    func profileViewModelCreator() -> UserProfileViewModel {
        let attributedText = NSMutableAttributedString(string: "\(username ?? ""),", attributes: [.font: AppFont.appFontStyle(size: 22, style: .bold)])
        let currentAge = age != nil ? "\(age!)" : ""
        let currentOccupation = occupation != nil ? "\(occupation!)" : ""
        attributedText.append(NSAttributedString(string: " \(currentAge)", attributes: [.font: AppFont.appFontStyle(size: 18, style: .bold)]))
        attributedText.append(NSAttributedString(string: "\n🍻\(currentOccupation)", attributes: [.font: AppFont.appFontStyle(size: 16, style: .bold)]))
        return UserProfileViewModel(attributedString: attributedText, imageNames: [imageUrl], infoLocation: .left)
    }
}
