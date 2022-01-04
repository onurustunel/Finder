//
//  Extension+UIViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 4.01.2022.
//

import UIKit
extension UIViewController {
    public func presentNextViewController(nextController: UIViewController) {
        let viewController = nextController
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}
