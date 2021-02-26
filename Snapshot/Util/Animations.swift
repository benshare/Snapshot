//
//  Animations.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/25/21.
//

import Foundation
import UIKit

extension UIView {
    func move(to destination: CGPoint, duration: TimeInterval,
              options: UIView.AnimationOptions, scale: CGFloat = 1) {
      UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
        self.center = destination
        self.frame.size = CGSize(width: self.frame.width * scale, height: self.frame.height * scale)
        self.alpha = 1
      }, completion: nil)
    }
}
