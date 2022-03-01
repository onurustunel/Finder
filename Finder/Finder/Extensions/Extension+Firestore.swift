//
//  Extension+Firestore.swift
//  Finder
//
//  Created by Onur Ustunel on 1.03.2022.
//

import Foundation
import Firebase

extension Firestore {
    func getCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(FirebasePath.userListPath).document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let info = snapshot?.data() else {
                let error = NSError(domain: "finder.com.Finder", code: 1000, userInfo: [NSLocalizedDescriptionKey: "User can not find"])
                completion(nil, error)
                return
            }
            let user = User(userData: info)
            completion(user, nil)
        }
    }
}
