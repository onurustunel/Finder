//
//  Matching.swift
//  Finder
//
//  Created by Onur Ustunel on 14.03.2022.
//

import Foundation
struct Matching {
    let username: String
    let profileImageUrl: String
    init(data: [String: Any]) {
        self.username = data["nameSurname"] as? String ?? ""
        self.profileImageUrl = data["imageUrl"] as? String ?? ""
    }
}
