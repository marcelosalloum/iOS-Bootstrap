//
//  UIColor+Custom.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 14/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Convenience Methods
extension UIColor {
    /// Init UIColor with values between 0 and 255 (instead of 0...1)
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }

    /// Generates a Random Color
    class var random: UIColor {
        return UIColor(CGFloat.random(in: 0...255), CGFloat.random(in: 0...255),
                       CGFloat.random(in: 0...255), CGFloat.random(in: 0...1))
    }
}

// MARK: - Custom Colors
extension UIColor {

    class var mainColor: UIColor {
        return UIColor(59.0, 141.0, 238.0)
    }

    class var mainColorHighlighted: UIColor {
        return UIColor(18.0, 102.0, 203.0)
    }

    class var whiteColorHighlighted: UIColor {
        return UIColor(white: 217.0 / 255.0, alpha: 1.0)
    }

    class var warningRedColor: UIColor {
        return UIColor(255.0, 59.0, 48.0)
    }

    class var gray80: UIColor {
        return UIColor(77.0, 80.0, 90.0)
    }

    class var gray50: UIColor {
        return UIColor(106.0, 110.0, 124.0)
    }

    class var gray30: UIColor {
        return UIColor(142.0, 142.0, 147.0)
    }

    class var gray20: UIColor {
        return UIColor(200.0, 204.0, 215.0)
    }

    class var gray5: UIColor {
        return UIColor(240.0, 243.0, 247.0)
    }

    class var navBarColor: UIColor {
        return UIColor(246.0, 247.0, 247.0)
    }
}
