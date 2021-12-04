//
//  SplashView.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit

class BackgroundGradient: BaseView {
    private let gradientLayer = CAGradientLayer()
    override func configureUI() {
        super.configureUI()
        gradientBackground()
    }
    private func gradientBackground() {
        gradientLayer.colors = [ConstantColor.splashGradientTop.cgColor, ConstantColor.splashGradientBottom.cgColor]
            gradientLayer.locations = [0.3, 1.3]
            layer.addSublayer(gradientLayer)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.frame
    }
}
