//
//  MathUtil.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/25/21.
//

import Foundation
import UIKit

func magnitudeOfPoint(p: CGPoint) -> CGFloat {
    return distanceBetweenPoints(p1: p, p2: CGPoint.zero)
}

func distanceBetweenPoints(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
}

func translatePointBy(point: inout CGPoint, translation: CGPoint) {
    point = CGPoint(x: point.x + translation.x, y: point.y + translation.y)
}
