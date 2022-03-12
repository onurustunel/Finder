//
//  Extension+UIView.swift
//  Finder
//
//  Created by Onur Ustunel on 24.11.2021.
//

import UIKit

struct AnchorConstraints {
    var top: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var trailing: NSLayoutConstraint?
    var leading: NSLayoutConstraint?
    var width: NSLayoutConstraint?
    var height: NSLayoutConstraint?
}
extension UIView {
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) -> AnchorConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchorConstraints = AnchorConstraints()
        if let top = top {
            anchorConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        if let bottom = bottom {
            anchorConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        if let leading = leading {
            anchorConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        if let trailing = trailing {
            anchorConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        if size.width != 0 {
            anchorConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            anchorConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        [anchorConstraints.top, anchorConstraints.bottom, anchorConstraints.trailing, anchorConstraints.leading, anchorConstraints.height, anchorConstraints.width].forEach { $0?.isActive = true }
        return anchorConstraints
    }
    func fillSuperView(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewTop = superview?.topAnchor {
            topAnchor.constraint(equalTo: superViewTop, constant: padding.top).isActive = true
        }
        if let superViewBottom = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superViewBottom, constant: -padding.bottom).isActive = true
        }
        if let superViewLeading = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superViewLeading, constant: padding.left).isActive = true
        }
        if let superViewTrailing = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superViewTrailing, constant: -padding.right).isActive = true
        }
    }
    func centerLocatedSuperView(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    func centerX(_ anchor: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: anchor).isActive = true
    }
    func centerY(_ anchor: NSLayoutYAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: anchor).isActive = true
    }
    func centerXSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }
    func centerYSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superViewCenterYAnchor).isActive = true
        }
    }
    @discardableResult
    func constraintHeight(_ height: CGFloat) -> AnchorConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = AnchorConstraints()
        constraints.height = heightAnchor.constraint(equalToConstant: height)
        constraints.height?.isActive = true
        return constraints
    }
    @discardableResult
    func constraintWidth(_ width: CGFloat) -> AnchorConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = AnchorConstraints()
        constraints.width = widthAnchor.constraint(equalToConstant: width)
        constraints.width?.isActive = true
        return constraints
    }
}
extension UIView {
  func addSubviews(_ views: UIView...) {
    for view in views {
      addSubview(view)
    }
  }
}
