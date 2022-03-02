//
//  LoginViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 3.3.2022.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    let containerView =  BackgroundGradient()
    let loginViewModel = LoginViewModel()
    lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.layer.cornerRadius = 20
        image.image = UIImage(named: "flame")
        image.clipsToBounds = true
        return image
    }()
    let textEmailAddress: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.keyboardType = .emailAddress
        textField.placeholder = "Your Email"
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return textField
    }()
    let textPassword: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.placeholder = "Your Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.isEnabled = false
        button.backgroundColor = ConstantColor.disableRegisterButton
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFont.appFontStyle(size: 20, style: .bold)
        button.setTitleColor(ConstantColor.splashGradientTop, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Want to create an account?", for: .normal)
        button.titleLabel?.font = AppFont.appFontStyle(size: 17, style: .bold)
        button.setTitleColor(.link, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.addTarget(self, action: #selector(alreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    private lazy var loginStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [logoImage, textEmailAddress, textPassword, loginButton])
        view.axis = .vertical
        view.spacing = 24
        return view
    }()
    let hud = JGProgressHUD(style: .dark)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        notificationObserve()
        hideKeyboard()
        registerViewModelObserve()
    }
    private func configureView() {
        view.addSubview(containerView)
        containerView.frame = view.bounds
        view.addSubview(loginStackView)
        view.addSubview(registerButton)
        stackViewConfigure()
    }
    private func stackViewConfigure() {
        view.addSubview(loginStackView)
        loginButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        loginStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 45, bottom: 0, right: 34))
        loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registerButton.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 32, right: 24))
    }
    private func notificationObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(captureKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(hideShownKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func textChanged(textField: UITextField) {
       if textField == textEmailAddress {
            loginViewModel.emailAdress = textField.text
        } else if textField == textPassword {
            loginViewModel.password = textField.text
        }
    }
    @objc func alreadyHaveAccount() {
        presentNextViewController(nextController: SignUpViewController())
    }
    @objc private func captureKeyboardShow(notification: Notification) {
        guard let keyboardEndValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardEndFrame = keyboardEndValue.cgRectValue
        let bottomSpace = view.frame.height - (loginStackView.frame.height + loginStackView.frame.origin.y)
        let differenceSpace = keyboardEndFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -differenceSpace - 12)
    }
    @objc private func login() {
        self.hideKeyboard()
        loginViewModel.createNewAccount { (error) in
            if let error = error {
                self.errorInformation(error: error)
                return
            }
        }
        hud.dismiss()
        let viewController = UINavigationController(rootViewController: UserListViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
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
    fileprivate func registerViewModelObserve() {
        loginViewModel.bindableValidDataChecker.assignValue {[weak self] (result) in
            guard let result = result else { return }
            if result {
                self?.loginButton.backgroundColor = ConstantColor.white
            } else {
                self?.loginButton.backgroundColor = ConstantColor.disableRegisterButton
            }
            self?.loginButton.isEnabled = result
        }
        loginViewModel.bindableLogin.assignValue { (registering) in
            if registering == true {
                self.hud.textLabel.text = "Welcome again..."
                self.hud.show(in: self.view)
            } else {
                self.hud.dismiss()
            }
        }
    }
    fileprivate func errorInformation(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "There is an error!"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
}
