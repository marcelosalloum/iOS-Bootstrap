//
//  UIColor+Custom.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 14/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func mainColor() -> UIColor {  // mainBlueColor
        return UIColor(red: 59.0 / 255.0, green: 141.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }

    class func mainColorHighlighted() -> UIColor {  // mainBlueColorHighlighted
        return UIColor(red: 18.0 / 255.0, green: 102.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }

    class func whiteColorHighlighted() -> UIColor {
        return UIColor(white: 217.0 / 255.0, alpha: 1.0)
    }

    class func warningRedColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 59.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
    }

    class func gray80() -> UIColor {
        return UIColor(red: 77.0 / 255.0, green: 80.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }

    class func gray50() -> UIColor {
        return UIColor(red: 106.0 / 255.0, green: 110.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
    }

    class func gray30() -> UIColor {
        return UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }

    class func gray20() -> UIColor {
        return UIColor(red: 200.0 / 255.0, green: 204.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    }

    class func gray5() -> UIColor {
        return UIColor(red: 240.0 / 255.0, green: 243.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }

    class func navBarColor() -> UIColor {
        return UIColor(red: 246.0 / 255.0, green: 247.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }

//    + (UIColor *)inactiveLockButtonColor
//    {
//    return [UIColor colorWithRed:176.0f / 255.0f green:178.0f / 255.0f blue:186.0f / 255.0f alpha:1.0];
//    }
//
//
//    + (UIColor *)lockerGreen
//    {
//    return [UIColor colorWithRed:61.0f / 255.0f green:201.0f / 255.0f blue:116.0f / 255.0f alpha:1.0];
//    }
//
//
//    + (UIColor *)lockerRed
//    {
//    return [UIColor colorWithRed:216.0f / 255.0f green:76.0f / 255.0f blue:76.0f / 255.0f alpha:1.0];
//    }
}
