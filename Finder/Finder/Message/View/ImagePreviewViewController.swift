//
//  ImagePreviewView.swift
//  Finder
//
//  Created by Onur Ustunel on 21.03.2022.
//

import UIKit
class ImagePreviewViewController: UIViewController {
    let image: UIImage?
    let contentView = UIView(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.95))
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
     init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    private func setViews() {
        view.addSubview(contentView)
        contentView.fillSuperView()
        contentView.addSubview(imageView)
        imageView.fillSuperView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
    }
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
