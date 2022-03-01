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
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getCurrentUser()
    }
    fileprivate func getCurrentUser() {
        self.cleanOldProfiles()
        Firestore.firestore().getCurrentUser { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.currentUser = user
            self.getUserData()
        }
    }
    
    private func getUserData() {
        let query = Firestore.firestore().collection("\(FirebasePath.userListPath)").whereField("age", isGreaterThanOrEqualTo: currentUser?.minimumAge ?? 18).whereField("age", isLessThanOrEqualTo: currentUser?.maximumAge ?? 90)
        query.getDocuments { (snapshot, error) in
            if let error = error { return }
            snapshot?.documents.forEach({ (snapshot) in
                let userData = snapshot.data()
                let user = User(userData: userData)
                self.usersProfileViewModel.append(user.profileViewModelCreator())
                if user.userID != self.currentUser?.userID {
                    self.createProfileFromUser(user: user)
                }
            })
        }
    }
    fileprivate func createProfileFromUser(user: User) {
        let profileView = UserProfileView(frame: .zero)
        profileView.profileDelegate = self
        profileView.userViewModel = user.profileViewModelCreator()
        profilesView.addSubview(profileView)
        profileView.fillSuperView()
    }
    @objc func refreshUserList() {
        usersProfileViewModel.removeAll()
        getCurrentUser()
    }
    @objc func goToSettings() {
        let viewController = SettingsTableViewController()
        viewController.settingsDelegate = self
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
    private func cleanOldProfiles() {
        profilesView.subviews.forEach { $0.removeFromSuperview() }
        usersProfileViewModel.removeAll()
    }
}
extension UserListViewController: SettingControllerDelegate {
    func settingsSaved() {
        getCurrentUser()
    }
}
extension UserListViewController: ProfileDetailDelegate {
    func showProfileDetail() {
        let viewController = UserDetailViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}
