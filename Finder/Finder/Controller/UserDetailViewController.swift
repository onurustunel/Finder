//
//  UserDetailViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 2.03.2022.
//

import UIKit

class UserDetailViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = ConstantColor.darkBackgroundColor
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }()
    let imageSlideController = ImageSlidePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "profileDismiss")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    var userDetail: UserProfileViewModel! {
        didSet {
            updateUI(userViewModel: userDetail)
        }
    }
    lazy var bottomView = ProfileDetailBottomView()
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let headerImage = imageSlideController.view {
        headerImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureUI() {
        let imageSlideView = imageSlideController.view ?? UIView()
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        scrollView.addSubviews(imageSlideView, infoLabel, dismissButton, bottomView)
        imageSlideView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        infoLabel.anchor(top: imageSlideView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        dismissButton.anchor(top: imageSlideView.bottomAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 25),
                             size: .init(width: 50, height: 50))
        bottomView.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    private func updateUI(userViewModel: UserProfileViewModel) {
        infoLabel.attributedText = userViewModel.attributedString
        imageSlideController.userViewModel = userViewModel
    }
}
extension UserDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let headerImage = imageSlideController.view {
            let yMove = scrollView.contentOffset.y
            var stretch = view.frame.width - 2 * yMove
            stretch = max(view.frame.width, stretch)
            headerImage.frame = CGRect(x: min(0, yMove), y: min(0, yMove), width: stretch, height: stretch)
        }
    }
}
