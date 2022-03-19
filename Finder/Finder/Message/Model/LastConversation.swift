//
//  LastConversation.swift
//  Finder
//
//  Created by Onur Ustunel on 19.03.2022.
//

import UIKit
import Firebase
struct LastConversation {
    let message: String
    let userID: String
    let username: String
    let imageUrl: String
    let timestamp: Timestamp
    init(data: [String: Any]) {
        self.message = data["message"] as? String ?? ""
        self.userID = data["userID"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
