//
//  RegisterViewModel.swift
//  Finder
//
//  Created by Onur Ustunel on 13.12.2021.
//

import UIKit
import Firebase

class RegisterViewModel {
    var emailAdress: String? {
        didSet {
            dataIsValid()
        }
    }
    var nameAndSurname: String? {
        didSet {
            dataIsValid()
        }
    }
    var password: String? {
        didSet {
            dataIsValid()
        }
    }
    var bindableImage = Bindable<UIImage>()
    var bindableValidDataChecker = Bindable<Bool>()
    var bindableSignUP = Bindable<Bool>()
    fileprivate func dataIsValid() {
        let dataValid = emailAdress?.isEmpty == false && nameAndSurname?.isEmpty == false && password?.isEmpty == false
        bindableValidDataChecker.value = dataValid
    }
    func createNewAccount(completion: @escaping (Error?) -> ()) {
        guard let emailAddress = emailAdress, let password = password  else { return }
        self.bindableSignUP.value = true
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            self.firebaseImageSave(completion: completion)
        }
    }

    fileprivate func firebaseImageSave(completion: @escaping (Error?) -> ()) {
        let imageName = UUID().uuidString
        let referance = Storage.storage().reference(withPath: "/Images/\(imageName)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.8) ?? Data()
        referance.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            referance.downloadURL { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                self.bindableSignUP.value = false
                let imageUrl = url?.absoluteString ?? ""
                self.createUserInfo(imageUrl: imageUrl, completion: completion)
            }
        }
    }
    fileprivate func createUserInfo (imageUrl: String, completion: @escaping (Error?) -> ()) {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let userDictionary = ["NameSurname": nameAndSurname ?? "",
                              "ImageUrl":imageUrl,
                              "userID": userID]
        Firestore.firestore().collection("UserList").document(userID).setData(userDictionary) { (error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
