//
//  Extension+UIFont.swift
//  Finder
//
//  Created by Onur Ustunel on 26.11.2021.
//

import UIKit
struct AppFont {
    enum FontsStyle: String {
        case normal = ""
        case regular = "-Regular"
        case bold = "-Bold"
        case boldItalic = "-BoldItalic"
    }
    static let appFontName = "Helvetica"
    static func appFont(size: CGFloat) -> UIFont {
        return UIFont(name: appFontName, size: size) ?? UIFont.systemFont(ofSize: 50)
    }
    static func appFontStyle(size: CGFloat, style: FontsStyle) -> UIFont {
        return UIFont(name: "\(appFontName)\(style.rawValue)", size: size) ?? UIFont.systemFont(ofSize: 80)
    }
}
