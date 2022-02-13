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
    override func viewDidLoad() {
        super.viewDidLoad()
       setNavigationBar()
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
    
    }
    
    @objc func chooseImage(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.chooseButtonImage = button
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      return headerView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    private func configureUI(){
        tableView.tableHeaderView = UIView()
    }
    private func headerView() -> UIView {
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
    }
}
extension SettingsTableViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as? UIImage
        let chooseButtonImage = (picker as? CustomImagePickerController)?.chooseButtonImage
        chooseButtonImage?.setImage(chosenImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        chooseButtonImage?.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

class CustomImagePickerController: UIImagePickerController {
    var chooseButtonImage: UIButton?
}
