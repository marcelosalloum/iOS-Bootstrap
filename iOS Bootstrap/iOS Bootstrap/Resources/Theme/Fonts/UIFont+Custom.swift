//
//  Fonts+Custom.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 14/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import UIKit

/// Struct used to call custom fonts without using String literals
private struct Fonts {
    struct ProximaNova {
        static let Black: String = "ProximaNova-Black"
        static let Bold: String = "ProximaNova-Bold"
        static let BoldItalic: String = "ProximaNova-Bold-Italic"
        static let ExtraBold: String = "ProximaNova-Extra-Bold"
        static let Light: String = "ProximaNova-Light"
        static let LightItalic: String = "ProximaNova-Light-Italic"
        static let Regular: String = "ProximaNova-Regular"
        static let RegularItalic: String = "ProximaNova-Regular-Italic"
        static let Semibold: String = "ProximaNova-Semibold"
        static let SemiboldItalic: String = "ProximaNova-Semibold-Italic"
    }

    struct HelveticaNeue {
        static let Bold: String = "HelveticaNeue-Bold"
    }

    struct Colfax {
        static let Bold: String = "Colfax-Bold"
        static let Medium: String = "Colfax-Medium"
        static let Regular: String = "Colfax-Regular"
    }
}

// MARK: - Custom Fonts static methods
extension UIFont {
    // MARK: - ProximaNova
    /// ProximaNova-Black
    class func proximaNovaBlack(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.Black, size: size)
    }

    /// ProximaNova-Bold
    class func proximaNovaBold(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.Bold, size: size)
    }

    /// ProximaNova-Bold-Italic
    class func proximaNovaBoldItalic(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.BoldItalic, size: size)
    }

    /// ProximaNova-Bold-Italic
    class func proximaNovaExtraBold(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.ExtraBold, size: size)
    }

    /// ProximaNova-Light
    class func proximaNovaLight(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.Light, size: size)
    }

    /// ProximaNova-Light-Italic
    class func proximaNovaLightItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.LightItalic, size: size)
    }

    /// ProximaNova-Regular
    class func proximaNovaRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.Regular, size: size)
    }

    /// ProximaNova-Regular-Italic
    class func proximaNovaRegularItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.RegularItalic, size: size)
    }

    /// ProximaNova-Semibold
    class func proximaNovaSemibold(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.Semibold, size: size)
    }

    /// ProximaNova-Semibold-Italic
    class func proximaNovaSemiboldItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.ProximaNova.SemiboldItalic, size: size)
    }

    // MARK: - HelveticaNeue
    /// HelveticaNeue-Bold
    class func helveticaNeueBold(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.HelveticaNeue.Bold, size: size)
    }

    // MARK: - Colfax
    /// Colfax-Bold
    class func colfaxBold(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.Colfax.Bold, size: size)
    }

    /// Colfax-Medium
    class func colfaxMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.Colfax.Medium, size: size)
    }

    /// Colfax-Regular
    class func colfaxRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.Colfax.Regular, size: size)
    }
}
