//
//  Animations.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/25/21.
//

import Foundation
import UIKit

extension UIView {
    func animate(startingSize: CGSize, startingCenter: CGPoint, endingSize: CGSize, endingCenter: CGPoint, duration: TimeInterval, delay: TimeInterval = 0, additional: @escaping () -> Void = {}, completion: @escaping ((Bool) -> Void) = {_ in }) {
        frame.size = startingSize
        center = startingCenter
        layoutSubviews()
        UIView.animate(withDuration: duration, delay: delay, options: [.curveLinear, .layoutSubviews, .allowAnimatedContent], animations: {
            self.frame.size = endingSize
            self.center = endingCenter
            additional()
        }, completion: completion)
    }
    
    func move(endingSize: CGSize, endingCenter: CGPoint, duration: TimeInterval, delay: TimeInterval = 0, additional: @escaping () -> Void = {}, completion: @escaping ((Bool) -> Void) = {_ in }) {
        UIView.animate(withDuration: duration, delay: delay, options: .layoutSubviews, animations: {
            self.frame.size = endingSize
            self.center = endingCenter
            additional()
        }, completion: completion)
    }
}
