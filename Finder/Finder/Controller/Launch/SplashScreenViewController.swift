//
//  SplashScreenViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit
import AVKit
import AVFoundation

class SplashScreenViewController: UIViewController {
    let splashView = SplashView()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBackground()
        configureView()
        join()
    }
    private func join() {
        splashView.registerButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        splashView.signinButton.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
    }
    @objc func goToRegister() {
        presentNextViewController(nextController: SignUpViewController())
    }
    @objc func goToSignIn() {
        presentNextViewController(nextController: LoginViewController())
    }
}
extension SplashScreenViewController {
    private func configureView() {
        view.addSubview(splashView)
        splashView.frame = view.bounds
    }
    private func makeBackground() {
        let gradientBackground =  BackgroundGradient()
        view.addSubview(gradientBackground)
        gradientBackground.fillSuperView()
    }
}


