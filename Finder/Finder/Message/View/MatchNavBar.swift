//
//  MatchNavBar.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
class MatchNavigationBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ConstantColor.darkBackgroundColor
        let icon = UIImageView(image: UIImage(named: "message")?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        icon.tintColor = #colorLiteral(red: 0.8616023064, green: 0.3684691787, blue: 0.4407086372, alpha: 1)
        let messages = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 21), textColor: #colorLiteral(red: 0.8616023064, green: 0.3684691787, blue: 0.4407086372, alpha: 1), textAlignment: .center)
        let feed = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 21), textColor: .gray, textAlignment: .center)
        createStackView(icon.setHeight(45), createHorizontalStackView(messages, feed, distribution: .fillEqually)).padTop(10)
        makeShadow(opacity: 0.15, radius: 10, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
    }    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
