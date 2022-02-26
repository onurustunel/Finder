//
//  SettingsTableViewCell.swift
//  Finder
//
//  Created by Onur Ustunel on 22.02.2022.
//

import UIKit
import Firebase

protocol ITextField {
    func nameTextField(textField: UITextField)
    func ageTextField(textField: UITextField)
    func occupationTextField(textField: UITextField)
    func aboutTextField(textField: UITextField)
}

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"
    var currentUser: User?
    var delegate: ITextField?
    class SettingsTextField: UITextField {
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 45)
        }
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0)
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0)
        }
    }
    
    lazy var textfield : SettingsTextField = {
        let textfield = SettingsTextField()
        return textfield
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(textfield)
        textfield.fillSuperView(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateCell(currentUser: User?, section: Int) {
        self.currentUser = currentUser
        switch section {
        case 1:
            textfield.placeholder = "Your name and surname..."
            textfield.text = currentUser?.username
            textfield.addTarget(self, action: #selector(nameTextChanged), for: .editingChanged)
        case 2:
            textfield.placeholder = "Age"
            textfield.keyboardType = .numberPad
            textfield.addTarget(self, action: #selector(ageTextChanged), for: .editingChanged)
            if let age = currentUser?.age {
                textfield.text = "\(age)"
            }
        case 3:
            textfield.placeholder = "Occupation..."
            textfield.text = currentUser?.occupation
            textfield.addTarget(self, action: #selector(occupationTextChanged), for: .editingChanged)
        case 4:
            textfield.placeholder = "About You..."
            textfield.text = ""
            textfield.addTarget(self, action: #selector(aboutTextChanged), for: .editingChanged)
        default:
            textfield.placeholder = ""
            textfield.text = ""
        }
    }
    
    @objc func nameTextChanged(textField: UITextField) {
        delegate?.nameTextField(textField: textfield)
        currentUser?.username = textfield.text
    }
    @objc func ageTextChanged(textField: UITextField) {
        if let age = Int(textfield.text ?? "-1") {
            delegate?.ageTextField(textField: textfield)
            currentUser?.age = age
        }
    }
    @objc func occupationTextChanged(textField: UITextField) {
        delegate?.occupationTextField(textField: textfield)
        currentUser?.occupation = textfield.text
    }
    @objc func aboutTextChanged(textField: UITextField) {
        delegate?.aboutTextField(textField: textfield)
        currentUser?.occupation = textfield.text
    }
}
