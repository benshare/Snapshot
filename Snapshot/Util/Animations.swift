//
//  Animations.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/25/21.
//

import Foundation
import UIKit

extension UIView {
    func move(endingSize: CGSize, endingCenter: CGPoint, duration: TimeInterval, delay: TimeInterval = 0, additional: @escaping () -> Void = {}, completion: @escaping ((Bool) -> Void) = {_ in }) {
        let startingSize = frame.size
        let startingCenter = center
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
                self.transform = CGAffineTransform(scaleX: xScale, y: yScale)
                self.center = endingCenter
            }, completion: completion)
        }
    }
    
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
                self.transform = CGAffineTransform(scaleX: xScale, y: yScale)
                self.center = endingCenter
            }, completion: completion)
        }
    }
}


