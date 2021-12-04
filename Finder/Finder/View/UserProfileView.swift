//
//  UserProfileView.swift
//  Finder
//
//  Created by Onur Ustunel on 25.11.2021.
//

import UIKit

class UserProfileView: UIView {
    var userViewModel: UserProfileViewModel! {
        didSet {
            updateUI()
            imageTopViewConfigure(count: userViewModel.imageNames.count)
        }
    }
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "gencay")
        return image
    }()
    fileprivate let gradientLayer = CAGradientLayer()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let frameLimit: CGFloat = 120
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        configureUI()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(profilePanGesture))
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePicture))
        addGestureRecognizer(tapGesture)
    }    
    @objc func profilePanGesture(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            superview?.subviews.forEach({ (subView) in
                subView.layer.removeAllAnimations()
            })
        case .changed:
            capturePanChanges(panGesture)
        case .ended:
            endPanGesture(panGesture)
        default:
            break
        }
    }
    var imageIndex = 0
    @objc func changePicture(tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: nil)
        let nextPhoto = location.x > frame.width / 2 ? true : false
        nextPhoto ? userViewModel.showNextImage() : userViewModel.showPreviousPhoto()
    }
    fileprivate func endPanGesture(_ panGesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1
        let hideProfile: Bool = abs(panGesture.translation(in: nil).x) > frameLimit
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
            if hideProfile {
                self.frame = CGRect(x: 1500 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
                self.removeFromSuperview()
            } else {
                self.transform = .identity
            }
        } completion: { (_) in
            print( "animation ended")
        }
    }
    fileprivate let imageBarStackView = UIStackView()
    fileprivate func imageBarPresenter() {
        addSubview(imageBarStackView)
        imageBarStackView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 4))
        imageBarStackView.spacing = 4
        imageBarStackView.distribution = .fillEqually
    }
    fileprivate func imageTopViewConfigure(count: Int) {
        (0..<count).forEach { (_) in
            let pView = UIView()
            pView.backgroundColor = ConstantColor.gray
            imageBarStackView.addArrangedSubview(pView)
        }
        imageBarStackView.arrangedSubviews.first?.backgroundColor = ConstantColor.white
        imageIndexObserve()
    }
    fileprivate func gradientLayerMaker() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.3, 1.3]
        layer.addSublayer(gradientLayer)
    }
    fileprivate func capturePanChanges(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: nil)
        let degree: CGFloat = translation.x / 10
        let radianAngle = (degree * .pi) / 180
        let rotateTransform = CGAffineTransform(rotationAngle: radianAngle)
        self.transform = rotateTransform.translatedBy(x: translation.x, y: translation.y)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.frame
    }
    private func configureUI() {
        addSubview(imageView)
        imageView.fillSuperView()
        gradientLayerMaker()
        addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,
                             padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        imageBarPresenter()
    }
    private func updateUI() {
        let imageName = userViewModel.imageNames.first ?? ""
        imageView.image = UIImage(named: imageName)
        usernameLabel.attributedText = userViewModel.attributedString
        usernameLabel.textAlignment = userViewModel.infoLocation
    }
    private func imageIndexObserve() {
        userViewModel.imageIndexObserver = { (index, image) in
            self.imageBarStackView.arrangedSubviews.forEach { (subView) in
                subView.backgroundColor = ConstantColor.gray
            }
            self.imageView.image = image
            self.imageBarStackView.arrangedSubviews[index].backgroundColor = ConstantColor.white
        }
    }
}
