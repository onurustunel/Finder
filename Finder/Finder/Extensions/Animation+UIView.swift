//
//  Animation+UIView.swift
//  Finder
//
//  Created by Onur Ustunel on 25.11.2021.
//

import UIKit
extension UIView {
    func animationFadein(startingAlpha: CGFloat, duration: Double, curve: AnimationOptions) {
        self.alpha = startingAlpha
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: curve) {
            self.alpha = 1
        }
    }
    func animationFadeOut(duration: Double, curve: AnimationOptions) {
        self.alpha = 1.0
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: curve) {
            self.alpha = 0
        }
    }
    func animationScale(scale: CGFloat, duration: Double, curve: AnimationOptions) {
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: curve, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    func animationTransform (duration: Double, xAxis: CGFloat, yAxis: CGFloat, curve: AnimationOptions) {
        self.transform = CGAffineTransform(translationX: xAxis, y: yAxis)
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: curve, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
}
