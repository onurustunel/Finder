//
//  ImageCell.swift
//  Finder
//
//  Created by Onur Ustunel on 21.03.2022.
//

import UIKit
protocol ImageCellTapped {
    func imageTapped(image: UIImage)
}

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    var messageConstraint: AnchorConstraints!
    let messageContainer = UIView(backgroundColor: .clear)
    var delegate: ImageCellTapped?
    var data: Message! {
        didSet {
            updateImage(data: data)
            if data.senderMe {
                messageConstraint.trailing?.isActive = true
                messageConstraint.leading?.isActive = false
            } else {
                messageConstraint.trailing?.isActive = false
                messageConstraint.leading?.isActive = true
            }
        }
    }
    lazy var showImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc fileprivate func imageTapped() {
        delegate?.imageTapped(image: showImage.image ?? UIImage())
    }
    private func configureUI() {
        addSubview(messageContainer)
        messageConstraint = messageContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor,
                                                    padding: .init(top: 4, left: 20, bottom: 4, right: 20))
        messageContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        messageContainer.layer.cornerRadius = 15
        messageContainer.addSubview(showImage)
        showImage.fillSuperView(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    private func updateImage(data: Message) {
        guard let url = URL(string: data.imageUrl) else { return }
        showImage.sd_setImage(with: url)
    }
}
