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
    let indicator = UIActivityIndicatorView()
    var shownTopProfileView: UserProfileView?
    var likeDislikesStatus = [String: Int]()
    var users = [String: User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getCurrentUser()
        }
    }
    fileprivate func getCurrentUser() {
        self.cleanOldProfiles()
        Firestore.firestore().getCurrentUser { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.currentUser = user
//            self.getUserData()
            self.getLikeDislikes()
        }
    }
    fileprivate func getLikeDislikes() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        Firestore.firestore().collection(FirebasePath.LikeDislike).document(userID).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let likeDislikesStatus = snapshot?.data() as? [String : Int] else {
                self.likeDislikesStatus.removeAll()
                self.getUserData()
                return
            }
            self.likeDislikesStatus = likeDislikesStatus
            self.getUserData()
        }
    }
    private func getUserData() {
        let query = Firestore.firestore().collection("\(FirebasePath.userListPath)").whereField("age", isGreaterThanOrEqualTo: currentUser?.minimumAge ?? 18).whereField("age", isLessThanOrEqualTo: currentUser?.maximumAge ?? 90).limit(to: 10)
        var previousProfileView: UserProfileView?
        shownTopProfileView = nil
        query.getDocuments { (snapshot, error) in
            if let error = error { return }
            snapshot?.documents.forEach({ (snapshot) in
                let userData = snapshot.data()
                let user = User(userData: userData)
                self.users[user.userID ?? ""] = user
                self.usersProfileViewModel.append(user.profileViewModelCreator())
                
                let isCurrentUser = user.userID == Auth.auth().currentUser?.uid
                let shownBefore = self.likeDislikesStatus[user.userID ?? ""] != nil
//                let shownBefore = false
                if !isCurrentUser && !shownBefore {
                    let profileView = self.createProfileFromUser(user: user)
                    if self.shownTopProfileView == nil {
                        self.shownTopProfileView = profileView
                    }
                    previousProfileView?.nextProfileView = profileView
                    previousProfileView = profileView
                }
            })
        }
        indicator.stopAnimating()
    }
    fileprivate func createProfileFromUser(user: User) -> UserProfileView {
        let profileView = UserProfileView(frame: .zero)
        profileView.profileDelegate = self
        profileView.userViewModel = user.profileViewModelCreator()
        profilesView.addSubview(profileView)
        profilesView.sendSubviewToBack(profileView)
        profileView.fillSuperView()
        return profileView
    }
    @objc func refreshUserList() {
        profilesView.subviews.forEach { $0.removeFromSuperview() }
        self.getCurrentUser()
    }
    //MARK:- Like a profile
    @objc func profileLiked() {
        transitionAnimation(liked: true)
        saveTransitions(status: 1)
    }
    @objc func dislikeProfile() {
        saveTransitions(status: -1)
        transitionAnimation(liked: false)
    }
    fileprivate func matchControl(profileID: String) {
        Firestore.firestore().collection(FirebasePath.LikeDislike).document(profileID).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            print(data)
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            let isMatched = data[currentUserID] as? Int == 1
            if isMatched {
                self.createMatchView(profileID: profileID)
                guard let matchedUser = self.users[profileID] else { return }
                let matchProfileData = ["nameSurname": matchedUser.username,
                                        "imageUrl": matchedUser.firstImageUrl,
                                        "userID": profileID,
                                        "timestamp": Timestamp(date: Date())] as [String: Any]
                Firestore.firestore().collection(FirebasePath.matchingMesage).document(currentUserID).collection(FirebasePath.matching).document(profileID).setData(matchProfileData) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
                guard let currentUser = self.currentUser else { return }
                let matchUserData = ["nameSurname": currentUser.username,
                                     "imageUrl": currentUser.firstImageUrl,
                                     "userID": currentUser.userID,
                                     "timestamp": Timestamp(date: Date())] as [String: Any]
                Firestore.firestore().collection(FirebasePath.matchingMesage).document(profileID).collection(FirebasePath.matching).document(currentUserID).setData(matchUserData) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }
    }
   
    fileprivate func saveTransitions(status: Int) {
        guard let userID = currentUser?.userID else { return }
        guard let profileID = shownTopProfileView?.userViewModel.userID else { return }
        let createData = [profileID: status]
        Firestore.firestore().collection(FirebasePath.LikeDislike).document(userID).getDocument { (snapshot, error) in
            if let error = error {
                print("Data could not get from server", error.localizedDescription)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection(FirebasePath.LikeDislike).document(userID).updateData(createData) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if status == 1 {
                        self.matchControl(profileID: profileID)
                    }
                }
            } else {
                Firestore.firestore().collection(FirebasePath.LikeDislike).document(userID).setData(createData) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if status == 1 {
                        self.matchControl(profileID: profileID)
                    }
                }
            }
        }
    }
    
    fileprivate func createMatchView(profileID: String) {
        let matchView = MatchView()
        matchView.profileID = profileID
        matchView.currentUser = currentUser
        view.addSubview(matchView)
        matchView.fillSuperView()
    }
    
    @objc func goToSettings() {
        let viewController = SettingsTableViewController()
        viewController.settingsDelegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc fileprivate func goToMessages() {
        let viewController = MatchMessageController()
        viewController.view.backgroundColor = .red
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    fileprivate func transitionAnimation(liked: Bool) {
        let constant: CGFloat =  liked ? 1 : -1
        let basicAnimation = CABasicAnimation(keyPath: "position.x")
        basicAnimation.toValue = constant * 800
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        basicAnimation.isRemovedOnCompletion = false
        let transform = CABasicAnimation(keyPath: "transform.rotation.z")
        transform.toValue = constant *  CGFloat.pi * 20 / 180
        transform.duration = 1
        let shownTopViewCopy = shownTopProfileView
        shownTopProfileView = shownTopViewCopy?.nextProfileView
        CATransaction.setCompletionBlock {
            shownTopViewCopy?.removeFromSuperview()
        }
        shownTopViewCopy?.layer.add(basicAnimation, forKey: "likeAnimation")
        shownTopViewCopy?.layer.add(transform, forKey: "transform")
        CATransaction.commit()
    }
}
//MARK:- Layout functions
extension UserListViewController {
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.05060279188, green: 0.05060279188, blue: 0.05060279188, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        let mainStackView = UIStackView(arrangedSubviews: [topStackView, profilesView, bottomStackView ])
        mainStackView.bringSubviewToFront(profilesView)
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        view.addSubview(mainStackView)
        view.addSubview(indicator)
        indicator.center = view.center
        indicator.startAnimating()
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
        bottomStackView.likeButton.addTarget(self, action: #selector(profileLiked), for: .touchUpInside)
        bottomStackView.closeButton.addTarget(self, action: #selector(dislikeProfile), for: .touchUpInside)
        topStackView.profileButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(goToMessages), for: .touchUpInside)
    }
    private func cleanOldProfiles() {
        profilesView.subviews.forEach { $0.removeFromSuperview() }
        usersProfileViewModel.removeAll()
    }
}
extension UserListViewController: SettingControllerDelegate {
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("User could not exit... Error", error.localizedDescription)
        }
        let viewController = SplashScreenViewController()
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true, completion: nil)
    }
    func settingsSaved() {
        getCurrentUser()
    }
}
extension UserListViewController: ProfileDetailDelegate {
    func likedUser(profile: UserProfileView) {
        saveTransitions(status: 1)
    }
    func dislikedUser(profile: UserProfileView) {
        saveTransitions(status: -1)
    }
    func removeProfileView(profile: UserProfileView) {
        self.shownTopProfileView?.removeFromSuperview()
        self.shownTopProfileView = self.shownTopProfileView?.nextProfileView
    }
    func showProfileDetail(userViewModel: UserProfileViewModel) {
        let viewController = UserDetailViewController()
        viewController.userDetail = userViewModel
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}
