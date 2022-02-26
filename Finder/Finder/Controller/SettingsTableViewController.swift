//
//  SettingsTableViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 13.02.2022.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class SettingsTableViewController: UITableViewController {
    
    lazy var firstImageButton = UIButton.buttonMaker(title: "Upload Image", selector: #selector(chooseImage), controller: self)
    lazy var secondImageButton = UIButton.buttonMaker(title: "Upload Image", selector: #selector(chooseImage), controller: self)
    lazy var thirdImageButton = UIButton.buttonMaker(title: "Upload Image", selector: #selector(chooseImage), controller: self)
    
    lazy var header: UIView = {
        let headerView = UIView()
        headerView.addSubview(firstImageButton)
        firstImageButton.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, leading: headerView.leadingAnchor, trailing: nil,
                                padding: .init(top: 15, left: 15, bottom: 15, right: 0))
        firstImageButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
        let stackView = UIStackView(arrangedSubviews: [secondImageButton, thirdImageButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        headerView.addSubview(stackView)
        stackView.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, leading: nil, trailing: headerView.trailingAnchor,
                         padding: .init(top: 15, left: 0, bottom: 15, right: 15))
        stackView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
        return headerView
    }()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        //        fastLogin()
        getUserData()
    }
    private func setNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed)),
            UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updatePersonalInfo))]
    }
    
    private func getUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("\(FirebasePath.userListPath)").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("User data is not reachable...")
                return
            }
            guard let userInfo = snapshot?.data() else { return }
            self.currentUser = User(userData: userInfo)
            self.getProfileImages()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func updatePersonalData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let updateData: [String : Any] = [
            "userID": uid,
            "age": currentUser?.age,
            "nameSurname": currentUser?.username ?? "",
            "occupation": currentUser?.occupation ?? "",
            "imageUrl": currentUser?.imageUrl ?? ""
        ]
        Firestore.firestore().collection("\(FirebasePath.userListPath)").document(uid).setData(updateData)
    }
    
    fileprivate func getProfileImages() {
        guard let profileImageUrl = currentUser?.imageUrl,
              let url = URL(string: "\(profileImageUrl)")  else { return }
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil){image,_,_,_,_,_ in
            self.firstImageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func fastLogin() {
        Auth.auth().signIn(withEmail: "ahmet@gmail.com", password: "******", completion: nil)
        print("test login")
    }
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func logoutPressed() {
        //NOTE: User will logout here...
    }
    @objc func updatePersonalInfo() {
        updatePersonalData()
    }
    @objc func chooseImage(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.changingButton = button
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = TitleLabel()
        headerLabel.textColor = ConstantColor.white
        headerLabel.text = SettingsConstant.headerTitles[section - 1]
        return headerLabel
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 300 : 55
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 0 : 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell {
            cell.updateCell(currentUser: currentUser, section: indexPath.section)
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    private func configureUI() {
        setNavigationBar()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.backgroundColor = #colorLiteral(red: 0.09608978426, green: 0.09608978426, blue: 0.09608978426, alpha: 1)
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
    }
}
extension SettingsTableViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let chosenButton = (picker as? CustomImagePickerController)?.changingButton
        chosenButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        chosenButton?.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
private class CustomImagePickerController: UIImagePickerController {
    var changingButton: UIButton?
}
private struct SettingsConstant {
    static let headerTitles: [String] = ["Name - Surname","Age","Occupation","About"]
}
extension SettingsTableViewController: ITextField {
    func nameTextField(textField: UITextField) {
        currentUser?.username = textField.text ?? ""
    }
    func ageTextField(textField: UITextField) {
        if let age = Int(textField.text ?? "-1") {
            currentUser?.age = age
        }
    }
    func occupationTextField(textField: UITextField) {
        currentUser?.occupation = textField.text ?? ""
    }
    func aboutTextField(textField: UITextField) {
        //NOTE: About will be added later...
    }
}
