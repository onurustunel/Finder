//
//  UserListViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 24.11.2021.
//

import UIKit
import Firebase

class UserListViewController: UIViewController {
    let topStackView = UserListTopStackView()
    let bottomStackView = UserListBottomStackView()
    let profilesView = UIView()
    var usersProfileViewModel = [UserProfileViewModel]()
    var lastUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureProfiles()
        getUserData()
    }
    
   private func getUserData() {
    let query = Firestore.firestore().collection("UserList").order(by: "userID").start(at: [lastUser?.userID ?? ""]).limit(to: 2)
    query.getDocuments { (snapshot, error) in
        if let error = error {
            return
        }
        snapshot?.documents.forEach({ (snapshot) in
            let userData = snapshot.data()
            let user = User(userData: userData)
            self.usersProfileViewModel.append(user.profileViewModelCreator())
            self.lastUser = user
            self.createProfileFromUser(user: user)
        })
//        self.configureProfiles()
    }
    }
    fileprivate func createProfileFromUser(user: User) {
        let profileView = UserProfileView(frame: .zero)
        profileView.userViewModel = user.profileViewModelCreator()
        profilesView.addSubview(profileView)
        profileView.fillSuperView()
    }
    @objc func refreshUserList() {
        usersProfileViewModel.removeAll()
        getUserData()
    }
    @objc func goToSettings() {
        let viewController = SettingsTableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
}
//MARK:- Layout functions
extension UserListViewController {
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
        buttonAction()
    }
    private func configureProfiles() {
        usersProfileViewModel.forEach { (userViewModel) in
            let profileView = UserProfileView(frame: .zero)
            profileView.userViewModel = userViewModel
            profilesView.addSubview(profileView)
            profileView.fillSuperView()
        }
    }
    private func buttonAction() {
        bottomStackView.refreshButton.addTarget(self, action: #selector(refreshUserList), for: .touchUpInside)
        topStackView.profileButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
    }
}
