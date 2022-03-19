//
//  ImageSlidePageViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 6.03.2022.
//

import UIKit
import SDWebImage

class ImageSlidePageViewController: UIPageViewController {
    var userViewModel: UserProfileViewModel! {
        didSet {
            updateUI()
        }
    }
    var controllers = [UIViewController]()
    fileprivate let barStackView: UIStackView = UIStackView(arrangedSubviews: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = ConstantColor.darkBackgroundColor
        makeBarView()
    }
    fileprivate func updateUI() {
        controllers = userViewModel.imageNames.map({ (imageUrl) -> UIViewController in
            let imageController = ImageController(imageUrl: imageUrl)
            return imageController
        })
        setViewControllers([controllers.first ?? ImageController(imageUrl: "")], direction: .forward, animated: true, completion: nil)
        createBarView()
    }
    fileprivate func createBarView() {
        if userViewModel.imageNames.count == 1 { return }
        userViewModel.imageNames.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = .gray
            barStackView.addArrangedSubview(barView)
        }
    }    
}
extension ImageSlidePageViewController {
    private func makeBarView() {
        view.addSubview(barStackView)
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
                            size: .init(width: 0, height: 4))
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.distribution = .fillEqually
        barStackView.spacing = 4
    }
}
extension ImageSlidePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let shownController = viewControllers?.first
        if let index = controllers.firstIndex(where: { $0 == shownController }) {
            barStackView.arrangedSubviews.forEach({ $0.backgroundColor = .gray })
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}
extension ImageSlidePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count - 1 { return nil}
        return controllers[index + 1]
    }
}

class ImageController: UIViewController {
    let imageView = UIImageView()
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = UIImage(named: "placeHolderProfil")
        }
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.fillSuperView()
    }
}
