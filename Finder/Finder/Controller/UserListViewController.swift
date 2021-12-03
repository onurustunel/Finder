//
//  UserListViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 24.11.2021.
//

import UIKit

class UserListViewController: UIViewController {
    let topStackView = UserListTopStackView()
    let bottomStackView = UserListBottomStackView()
    let profilesView = UIView()
    var users : [UserProfileViewModel] = {
   let profiles = [User(username: "Gencay1", occupation: "Istanbul", age: 11, imageNames: ["gencay", "nike", "gencay"]),
    User(username: "Gencay2", occupation: "Istanbul", age: 22, imageNames:  ["gencay"]),
    User(username: "Gencay2", occupation: "Istanbul", age: 33, imageNames:  ["gencay", "nike"]),
    Advertise(title: "November Sale", brandName: "Nike", imageName: "nike", infoLocation: .center)] as [UserProfileViewModelCreator]
        let viewModels = profiles.map(({ $0.profileViewModelCreator() }))
        return viewModels
    }()
            override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureProfiles()
    }
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.85)
        navigationController?.navigationBar.isHidden = true
        let mainStackView = UIStackView(arrangedSubviews: [topStackView, profilesView, bottomStackView ])
        mainStackView.bringSubviewToFront(profilesView)
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    private func configureProfiles() {
        users.forEach { (userViewModel) in
            let profileView = UserProfileView(frame: .zero)
            profileView.userViewModel = userViewModel
            profilesView.addSubview(profileView)
            profileView.fillSuperView()
        }
    }
}
