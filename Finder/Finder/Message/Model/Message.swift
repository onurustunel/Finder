//
//  Message.swift
//  Finder
//
//  Created by Onur Ustunel on 17.03.2022.
//

import Foundation
import Firebase

struct Message {
    let message: String
    let senderMe: Bool
    let sender: String
    let receiver: String
    let timestamp: Timestamp
    init(data: [String: Any]) {
        self.message = data["message"] as? String ?? ""
        self.sender = data["senderID"] as? String ?? ""
        self.receiver = data["receiverID"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.senderMe = Auth.auth().currentUser?.uid == self.sender
    }
}
