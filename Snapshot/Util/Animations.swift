//
//  Animations.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/25/21.
//

import Foundation
import UIKit

extension UIView {
    // Move from/to specific points
    func move(startingSize: CGSize, startingCenter: CGPoint, endingSize: CGSize, endingCenter: CGPoint, duration: TimeInterval, delay: TimeInterval = 0, additional: @escaping () -> Void = {}, completion: @escaping ((Bool) -> Void) = {_ in }) {
        let xScale = endingSize.width / startingSize.width
        let yScale = endingSize.height / startingSize.height
        
        if xScale > 1 || yScale > 1 {
            frame.size = endingSize
            self.transform = CGAffineTransform(scaleX: 1 / xScale, y: 1 / yScale)
            center = startingCenter
            UIView.animate(withDuration: duration, delay: delay, options: .layoutSubviews, animations: {
                self.transform = .identity
                self.center = endingCenter
            }, completion: completion)
        } else {
            UIView.animate(withDuration: duration, delay: delay, options: .layoutSubviews, animations: {
                self.frame.size = endingSize
                self.center = endingCenter
            }, completion: completion)
        }
    }
    
    // Move from current position to specific point
    func move(endingSize: CGSize, endingCenter: CGPoint, duration: TimeInterval, delay: TimeInterval = 0, additional: @escaping () -> Void = {}, completion: @escaping ((Bool) -> Void) = {_ in }) {
        self.move(startingSize: self.frame.size, startingCenter: self.center, endingSize: endingSize, endingCenter: endingCenter, duration: duration, delay: delay, additional: additional, completion: completion)
    }
    
    // Move from current position to specific anchor point
//    func move(endingSize: CGSize, to anchor: UIView, duration: TimeInterval, delay: TimeInterval = 0, additional: @escaping () -> Void = {}, completion: @escaping ((Bool) -> Void) = {_ in }) {
//        UIView.animate(withDuration: duration, delay: delay, options: .layoutSubviews, animations: {
//            self.center = anchor.center
//            self.frame.size = endingSize
//        }, completion: completion)
//    }
}

