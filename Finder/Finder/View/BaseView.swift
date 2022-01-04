//
//  BaseView.swift
//  Finder
//
//  Created by Onur Ustunel on 4.12.2021.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
        self.updateUI()
    }
    func configureUI() {
    }
    func updateUI() {
    }
}
