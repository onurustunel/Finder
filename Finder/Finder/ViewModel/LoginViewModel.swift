//
//  LoginViewModel.swift
//  Finder
//
//  Created by Onur Ustunel on 2.03.2022.
//

import UIKit
import Firebase

class LoginViewModel {
    var emailAdress: String? {
        didSet {
            dataIsValid()
        }
    }
    var password: String? {
        didSet {
            dataIsValid()
        }
    }
    var bindableValidDataChecker = Bindable<Bool>()
    var bindableLogin = Bindable<Bool>()
    fileprivate func dataIsValid() {
        let dataValid = emailAdress?.isEmpty == false && password?.isEmpty == false
        bindableValidDataChecker.value = dataValid
    }
    func createNewAccount(completion: @escaping (Error?) -> ()) {
        guard let emailAddress = emailAdress, let password = password  else { return }
        self.bindableLogin.value = true
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
         
        }
    }

}
