//
//  ThemesUtil.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/2/21.
//

import Foundation
import UIKit

func globalBackgroundColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return UIColor.systemBackground
    } else {
        return UIColor.white
    }
}

func globalTextColor() -> UIColor {
    if #available(iOS 13.0, *) {
        return UIColor.label
    } else {
        return UIColor.black
    }
}
