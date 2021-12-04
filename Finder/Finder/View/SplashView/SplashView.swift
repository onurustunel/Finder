//
//  SplashView.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit

class SplashView: BaseView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: 350).isActive = true
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    private lazy var sloganLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.appFontStyle(size: 40, style: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.appFontStyle(size: 18, style: .normal)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(  " Register ", for: .normal)
        button.backgroundColor = ConstantColor.white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFont.appFontStyle(size: 20, style: .bold)
        button.setTitleColor(ConstantColor.splashGradientTop, for: .normal)
        return button
    }()
    let signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(  " Sign In ", for: .normal)
        button.backgroundColor = ConstantColor.white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFont.appFontStyle(size: 20, style: .bold)
        button.setTitleColor(ConstantColor.splashGradientTop, for: .normal)
        return button
    }()
    override func configureUI() {
        super.configureUI()
        configureAnchor()
        configureAnimation(view: [imageView, sloganLabel, descriptionLabel, registerButton, registerButton])
    }
    override func updateUI() {
        super.updateUI()
        DispatchQueue.main.async {
            self.imageView.image = UIImage(named: "splashImage")
            self.sloganLabel.text = "Find your best with Finder"
            self.descriptionLabel.text = "Finder helps you to find new friends around you. There is too many users in Finder and Thousand of people join us everyday"
        }
    }
    private func configureAnchor() {
        addSubviews(imageView, sloganLabel, descriptionLabel)
        addSubviews(registerButton, signinButton)
        imageView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        sloganLabel.anchor(top: imageView.bottomAnchor, bottom: nil, leading: imageView.leadingAnchor, trailing: imageView.trailingAnchor, padding: .init(top: 32, left: 0, bottom: 0, right: 0))
        descriptionLabel.anchor(top: sloganLabel.bottomAnchor, bottom: nil, leading: sloganLabel.leadingAnchor, trailing: sloganLabel.trailingAnchor,
                                padding: .init(top: 32, left: 20, bottom: 0, right: 20))
        registerButton.anchor(top: nil, bottom: safeAreaLayoutGuide.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor,
                              padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .init(width: 0, height: 44))
        signinButton.anchor(top: nil, bottom: registerButton.topAnchor, leading: leadingAnchor, trailing: trailingAnchor,
                            padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .init(width: 0, height: 44))
    }
    private func configureAnimation(view: [UIView]) {
        view.forEach { (view) in
            view.animationFadein(startingAlpha: 0.3, duration: 1, curve: .curveEaseInOut)
        }
    }    
}
