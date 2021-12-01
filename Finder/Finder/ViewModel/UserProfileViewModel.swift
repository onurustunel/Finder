//
//  UserProfileViewModel.swift
//  Finder
//
//  Created by Onur Ustunel on 30.11.2021.
//

import UIKit

struct UserProfileViewModel {
    let attributedString : NSAttributedString
    let imageNames : [String]
    let infoLocation : NSTextAlignment
    
}

protocol UserProfileViewModelCreator {
    func profileViewModelCreator() -> UserProfileViewModel
}
