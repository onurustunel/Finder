//
//  RegisterViewModel.swift
//  Finder
//
//  Created by Onur Ustunel on 13.12.2021.
//

import UIKit
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
    fileprivate func dataIsValid() {
        let dataValid = emailAdress?.isEmpty == false && nameAndSurname?.isEmpty == false && password?.isEmpty == false
        bindableValidDataChecker.value = dataValid
    }    
}
