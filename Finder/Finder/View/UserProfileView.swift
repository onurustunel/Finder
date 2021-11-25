//
//  UserProfileView.swift
//  Finder
//
//  Created by Onur Ustunel on 25.11.2021.
//

import UIKit

class UserProfileView: UIView {
    private lazy var imageView: UIImageView = {
       let image = UIImageView()
       image.contentMode = .scaleAspectFill
       image.clipsToBounds = true
       image.image = UIImage(named: "gencay")
       return image
     }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        configureUI()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(profilePanGesture))
        addGestureRecognizer(panGesture)
    }
    @objc func profilePanGesture(panGesture: UIPanGestureRecognizer) {
    
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func configureUI() {
        addSubview(imageView)
        imageView.fillSuperView()
    }
}
