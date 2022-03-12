//
//  MatchView.swift
//  Finder
//
//  Created by Onur Ustunel on 11.03.2022.
//

import UIKit
import Firebase

class MatchView: BaseView {
    fileprivate let imageSize: CGFloat = 140
    let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var currentUser: User!
    
    var profileID: String! {
        didSet {
            updateMatchView()
        }
    }
    private lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "gencay")
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        image.layer.cornerRadius = imageSize / 2
        image.clipsToBounds = true
        image.alpha = 0
        return image
    }()
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        image.layer.cornerRadius = imageSize / 2
        image.clipsToBounds = true
        image.alpha = 0
        return image
    }()
    private lazy var matchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "SnellRoundhand-Black", size: 40)
        label.textAlignment = .center
        label.text = "It's a match!!!"
        return label
    }()
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.appFontStyle(size: 20, style: .normal)
        label.alpha = 0.7
        label.textAlignment = .center
        return label
    }()
    
    let messageButton: UIButton = {
        let button = GradientButton(type: .system)
        button.setTitle(  " SEND MESSAGE ", for: .normal)
//        button.backgroundColor = ConstantColor.white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFont.appFontStyle(size: 20, style: .normal)
        button.setTitleColor(ConstantColor.white, for: .normal)
        return button
    }()
    let keepSwipeButton: UIButton = {
        let button = GradientBorderButton(type: .system)
        button.setTitle(  " KEEP SWIPE ", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFont.appFontStyle(size: 20, style: .normal)
        button.setTitleColor(ConstantColor.white, for: .normal)
        button.addTarget(self, action: #selector(hideMatchView), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
        visualViewShow()
        setView()
        updateText()
        
    }
    override func updateUI() {
        super.updateUI()
    }
    fileprivate func updateText() {
        infoLabel.text = "You matched with \("Ali")"
    }
    
    fileprivate func visualViewShow() {
        addSubview(visualView)
        visualView.fillSuperView()
        visualView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideMatchView)))
        visualView.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.visualView.alpha = 1
        } completion: { (_) in
            // done
        }
    }
    @objc fileprivate func hideMatchView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }
    fileprivate func updateMatchView() {
        let query = Firestore.firestore().collection(FirebasePath.userListPath)
        query.document(profileID).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let profileData = snapshot?.data() else { return }
            let user = User(userData: profileData)
            guard let profileImageUrl = URL(string: user.firstImageUrl ?? "") else { return }
            guard let currentUserImageProfile = URL(string: self.currentUser.firstImageUrl ?? "") else { return }
            self.profileImage.sd_setImage(with: profileImageUrl)
            self.profileImage.alpha = 1
            self.userImage.sd_setImage(with: currentUserImageProfile)
            self.userImage.alpha = 1
            self.infoLabel.text = "You matched with \(user.username ?? "New User")"            
        }
    }
}
extension MatchView {
    fileprivate func setView() {
        addSubviews(userImage, profileImage, matchLabel, infoLabel, messageButton, keepSwipeButton)
        setConstraints()
        customAnimations()
    }

    fileprivate func setConstraints() {
        userImage.anchor(top: nil, bottom: nil, leading: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: imageSize, height: imageSize))
        userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.anchor(top: nil, bottom: nil, leading: self.centerXAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: imageSize, height: imageSize))
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        matchLabel.anchor(top: self.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 230, left: 0, bottom: 0, right: 0))
        infoLabel.anchor(top: matchLabel.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 40, bottom: 0, right: 40))
        messageButton.anchor(top: userImage.bottomAnchor, bottom: nil, leading: userImage.leadingAnchor, trailing: profileImage.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0),
                             size: .init(width: 0, height: 50))
        keepSwipeButton.anchor(top: messageButton.bottomAnchor, bottom: nil, leading: userImage.leadingAnchor, trailing: profileImage.trailingAnchor,
        padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
    }
    
    fileprivate func customAnimations() {
        matchLabel.animationFadein(startingAlpha: 0.2, duration: 0.5, curve: .curveEaseIn)
        userImage.animationTransform(duration: 0.6, xAxis: 400, yAxis: 0, curve: .curveEaseIn)
        profileImage.animationTransform(duration: 0.6, xAxis: -400, yAxis: 0, curve: .curveEaseIn)
        messageButton.animationTransform(duration: 0.6, xAxis: 200, yAxis: 0, curve: .curveEaseIn)
        keepSwipeButton.animationTransform(duration: 0.6, xAxis: -200, yAxis: 0, curve: .curveEaseIn)
    }
}
