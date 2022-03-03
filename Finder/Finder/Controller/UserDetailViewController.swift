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
        scrollView.backgroundColor = UIColor(red: 0.097, green: 0.097, blue: 0.097, alpha: 1)
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }()
    lazy var headerImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        scrollView.addSubviews(headerImage, infoLabel, dismissButton, bottomView)
        headerImage.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        configureAnchor()
    }
    private func updateUI(userViewModel: UserProfileViewModel) {
        infoLabel.attributedText = userViewModel.attributedString
        guard let imageUrl = userViewModel.imageNames.first, let url = URL(string: imageUrl) else { return }
        headerImage.sd_setImage(with: url)
    }

}
extension UserDetailViewController {
    private func configureAnchor() {
        infoLabel.anchor(top: headerImage.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        dismissButton.anchor(top: headerImage.bottomAnchor, bottom: nil, leading: nil, trailing: headerImage.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 25),
                             size: .init(width: 50, height: 50))
        bottomView.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
    }
}
extension UserDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yMove = scrollView.contentOffset.y
        var stretch = view.frame.width - 2 * yMove
        stretch = max(view.frame.width, stretch)
        headerImage.frame = CGRect(x: min(0, yMove), y: min(0, yMove), width: stretch, height: stretch)
    }
}
