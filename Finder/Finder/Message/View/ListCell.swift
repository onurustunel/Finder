//
//  ListCell.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
open class ListCell<T>: UICollectionViewCell {
    var data: T!
    var neededController: UIViewController?
    public let seperatorView = UIView(backgroundColor: UIColor(white: 0.65, alpha: 0.2))
    func addSeperator(leftSpacing: CGFloat = 0) {
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor,
                             padding: .init(top: 0, left: leftSpacing, bottom: 0, right: 0), size: .init(width: 0, height: 0.1))
    }
    func addSeperator(leadingAnchor: NSLayoutXAxisAnchor) {
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor,
                             size: .init(width: 0, height: 1))    
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ConstantColor.darkBackgroundColor
        configureUI()
    }
    open func configureUI() { }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
