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
    var firstImageUrl: String?
    var secondImageUrl: String?
    var thirdImageUrl: String?
    var minimumAge: Int?
    var maximumAge: Int?
    
    internal init(userData: [String : Any]) {
        self.userID = userData["userID"] as? String ?? ""
        self.username = userData["nameSurname"] as? String ?? ""
        self.age = userData["age"] as? Int
        self.occupation = userData["occupation"] as? String
        self.firstImageUrl = userData["imageUrl"] as? String
        self.secondImageUrl = userData["secondImageUrl"] as? String
        self.thirdImageUrl = userData["thirdImageUrl"] as? String
        self.minimumAge = userData["minimumAge"] as? Int
        self.maximumAge = userData["maximumAge"] as? Int
    }  
    func profileViewModelCreator() -> UserProfileViewModel {
        let attributedText = NSMutableAttributedString(string: "\(username ?? ""),", attributes: [.font: AppFont.appFontStyle(size: 24, style: .bold)])
        let currentAge = age != nil ? "\(age!)" : ""
        let currentOccupation = occupation != nil ? "\(occupation!)" : ""
        attributedText.append(NSAttributedString(string: " \(currentAge)", attributes: [.font: AppFont.appFontStyle(size: 20, style: .bold)]))
        attributedText.append(NSAttributedString(string: "\n🍻\(currentOccupation)", attributes: [.font: AppFont.appFontStyle(size: 18, style: .bold)]))
        var imageURL = [String]()
        if let url = firstImageUrl, !url.isEmpty { imageURL.append(url) }
        if let url = secondImageUrl, !url.isEmpty { imageURL.append(url) }
        if let url = thirdImageUrl, !url.isEmpty { imageURL.append(url) }
        return UserProfileViewModel(attributedString: attributedText, imageNames: imageURL, infoLocation: .left, userID: self.userID ?? "")
    }
}
