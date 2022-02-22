//
//  SettingsTableViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 13.02.2022.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func setNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed))
    }
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func logoutPressed() {
        //NOTE: User will logout here...
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
            cell.textfield.placeholder = SettingsConstant.infoPlaceHolders[indexPath.section - 1]
            return cell
        } else {
            return UITableViewCell()
        }        
    }
    private func configureUI() {
        setNavigationBar()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.2514982877)
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
    static let infoPlaceHolders: [String] = ["Name and Surname...","Your Age...",
                                             "Your Occupation...","About You..."]
}
