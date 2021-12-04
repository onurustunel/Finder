//
//  LoginViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit

class LoginViewController: UIViewController {
    let splashView =  BackgroundGradient()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView() {
        view.addSubview(splashView)
        splashView.frame = view.bounds
    }

}
