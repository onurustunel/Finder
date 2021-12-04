//
//  SignUpViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    let splashView =  BackgroundGradient()
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        image.layer.cornerRadius = 20
        image.image = UIImage(named: "gencay")
        image.clipsToBounds = true
        return image
    }()
    let textName: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.keyboardType = .emailAddress
        textField.placeholder = "Your Name:"
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return textField
    }()
    let textEmailAddress: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.keyboardType = .emailAddress
        textField.placeholder = "Your Email:"
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return textField
    }()
    let textPassword: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.placeholder = "Your Password:"
        textField.isSecureTextEntry = true
        return textField
    }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(  "Sign Up", for: .normal)
        button.isEnabled = false
        button.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFont.appFontStyle(size: 20, style: .bold)
        button.setTitleColor(ConstantColor.splashGradientTop, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return button
    }()
    private lazy var signUpStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [profileImage, textName, textEmailAddress, textPassword, signUpButton])
        view.axis = .vertical
        view.spacing = 24
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        notificationObserve()
        hideKeyboard()
    }
    private func configureView() {
        view.addSubview(splashView)
        splashView.frame = view.bounds
        view.addSubview(signUpStackView)
        stackViewConfigure()
    }
    private func stackViewConfigure() {
        view.addSubview(signUpStackView)
        signUpButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        signUpStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 45, bottom: 0, right: 34))
        signUpStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    private func notificationObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(captureKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideShownKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func textChanged(textField: UITextField) {
        if textField.text != "" {
            signUpButton.backgroundColor = ConstantColor.white
            signUpButton.isEnabled = true
        }
    }
    @objc private func captureKeyboardShow(notification: Notification) {
        guard let keyboardEndValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardEndFrame = keyboardEndValue.cgRectValue
        let bottomSpace = view.frame.height - (signUpStackView.frame.height + signUpStackView.frame.origin.y)
        let differenceSpace = keyboardEndFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -differenceSpace - 12)
    }
    private func hideKeyboard() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideShownKeyboard)))
    }
    @objc private func hideShownKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear) {
            self.view.transform = .identity
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
}
