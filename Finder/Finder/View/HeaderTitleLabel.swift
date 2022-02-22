//
//  HeaderTitleLabel.swift
//  Finder
//
//  Created by Onur Ustunel on 23.02.2022.
//

import UIKit
class TitleLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 25, dy: 0))
    }
}
