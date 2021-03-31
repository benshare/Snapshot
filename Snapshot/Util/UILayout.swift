//
//  UILayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/30/21.
//

import Foundation
import UIKit

class UILayout {
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []
    
    func removeConstraintsForRow(row: UIView) {
        var i = 0
        while i < portraitConstraints.count {
            let constraint = portraitConstraints[i]
            if constraint.firstItem as? NSObject == row || constraint.secondItem as? NSObject == row {
                portraitConstraints.remove(at: i)
                i -= 1
            }
            i += 1
        }
        while i < landscapeConstraints.count {
            let constraint = landscapeConstraints[i]
            if constraint.firstItem as? NSObject == row || constraint.secondItem as? NSObject == row {
                landscapeConstraints.remove(at: i)
                i -= 1
            }
            i += 1
        }
    }
}
