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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        var hexColor: String
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...]).lowercased()
        } else {
            hexColor = hex.lowercased()
        }
        if hexColor.count == 6 {
            hexColor += "ff"
        }
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255

            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }

        return nil
    }
    
    func lighter(by percentage: CGFloat = 20.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 20.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
