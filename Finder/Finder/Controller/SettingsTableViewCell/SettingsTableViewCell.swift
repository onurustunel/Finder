//
//  SettingsTableViewCell.swift
//  Finder
//
//  Created by Onur Ustunel on 22.02.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"
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
    
}
