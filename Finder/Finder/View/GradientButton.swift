//
//  GradientButton.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
class GradientButton : UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradientLayer = CAGradientLayer()
        let startColor = #colorLiteral(red: 0.9484000802, green: 0.1511048377, blue: 0.4636765718, alpha: 1)
        let endColor = #colorLiteral(red: 0.9971984029, green: 0.4618438482, blue: 0.3304074407, alpha: 1)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}
