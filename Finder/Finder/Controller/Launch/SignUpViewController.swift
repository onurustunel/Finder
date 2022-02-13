//
//  SignUpViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit
import Firebase
import JGProgressHUD

class SignUpViewController: UIViewController {
    let containerView =  BackgroundGradient()
    let registerViewModel = RegisterViewModel()
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
        button.backgroundColor = ConstantColor.disableRegisterButton
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFont.appFontStyle(size: 20, style: .bold)
        button.setTitleColor(ConstantColor.splashGradientTop, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    private lazy var signUpStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [profileImage, textName, textEmailAddress, textPassword, signUpButton])
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
        view.addSubview(signUpStackView)
        stackViewConfigure()
        selectImageGesture()
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
        if textField == textName {
            registerViewModel.nameAndSurname = textField.text
        } else if textField == textEmailAddress {
            registerViewModel.emailAdress = textField.text
        } else if textField == textPassword {
            registerViewModel.password = textField.text
        }
    }
    @objc private func captureKeyboardShow(notification: Notification) {
        guard let keyboardEndValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardEndFrame = keyboardEndValue.cgRectValue
        let bottomSpace = view.frame.height - (signUpStackView.frame.height + signUpStackView.frame.origin.y)
        let differenceSpace = keyboardEndFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -differenceSpace - 12)
    }
    @objc private func createAccount() {
        self.hideKeyboard()
        registerViewModel.createNewAccount { (error) in
            if let error = error {
                self.errorInformation(error: error)
                return
            }
        }
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
    private func selectImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(choseImageFromGallery))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
    }
    @objc fileprivate func choseImageFromGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    fileprivate func registerViewModelObserve() {
        registerViewModel.bindableValidDataChecker.assignValue {[weak self] (result) in
            guard let result = result else { return }
            if result {
                self?.signUpButton.backgroundColor = ConstantColor.white
            } else {
                self?.signUpButton.backgroundColor = ConstantColor.disableRegisterButton
            }
            self?.signUpButton.isEnabled = result
        }
        registerViewModel.bindableImage.assignValue { [weak self] (image) in
            self?.profileImage.image = image
        }
        registerViewModel.bindableSignUP.assignValue { (registering) in
            if registering == true {
                self.hud.textLabel.text = "Your Account is creating..."
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
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        registerViewModel.bindableImage.value = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
