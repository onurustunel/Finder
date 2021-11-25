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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureProfiles()
    }
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.85)
        navigationController?.navigationBar.isHidden = true
        let mainStackView = UIStackView(arrangedSubviews: [topStackView, profilesView, bottomStackView ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    private func configureProfiles() {
        let profileView = UserProfileView(frame: .zero)
        profilesView.addSubview(profileView)
        profileView.fillSuperView()        
    }
    
}
