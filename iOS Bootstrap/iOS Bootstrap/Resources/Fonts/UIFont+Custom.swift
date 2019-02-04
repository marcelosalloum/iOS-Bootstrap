//
//  Fonts+Custom.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 14/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation
import UIKit

private struct CustomFont {
    static let name: String = "ProximaNova"
    static let ExtraBold: String = "Extrabld"
    static let Black: String = "Black"
    static let Bold: String = "Bold"
    static let Italic: String = "It"
    static let Light: String = "Light"
    static let Regular: String = "Regular"
    static let Semibold: String = "Semibold"
}

extension UIFont {
    // MARK: - ProximaNova.Regular
    class func withSize(_ size: CGFloat) -> UIFont? {
        return self.withSize(size, italic: false)
    }

    class func withSize(_ size: CGFloat, italic: Bool) -> UIFont? {
        return self.regular(withSize: size, italic: italic)
    }

    class func regular(withSize size: CGFloat) -> UIFont? {
        return self.regular(withSize: size, italic: false)
    }

    class func regular(withSize size: CGFloat, italic: Bool) -> UIFont? {
        let attributes = italic ? [CustomFont.Regular, CustomFont.Italic] : [CustomFont.Regular]
        return UIFont.init(attributes: attributes, size: size)
    }

    // MARK: - ProximaNova.Black
    class func black(withSize size: CGFloat) -> UIFont? {
        return UIFont(attributes: [CustomFont.Black], size: size)
    }

    // MARK: - ProximaNova.Bold
    class func bold(withSize size: CGFloat) -> UIFont? {
        return self.bold(withSize: size, italic: false)
    }

    class func bold(withSize size: CGFloat, italic: Bool) -> UIFont? {
        let attributes = italic ? [CustomFont.Bold, CustomFont.Italic] : [CustomFont.Bold]
        return UIFont(attributes: attributes, size: size)
    }

    // MARK: - ProximaNova.ExtraBold
    class func extraBold(withSize size: CGFloat) -> UIFont? {
        return UIFont(attributes: [CustomFont.ExtraBold], size: size)
    }

    // MARK: - ProximaNova.Light
    class func light(withSize size: CGFloat) -> UIFont? {
        return self.light(withSize: size, italic: false)
    }

    class func light(withSize size: CGFloat, italic: Bool) -> UIFont? {
        let attributes = italic ? [CustomFont.Light, CustomFont.Italic] : [CustomFont.Light]
        return UIFont(attributes: attributes, size: size)
    }

    // MARK: - ProximaNova.Semibold
    class func semibold(withSize size: CGFloat) -> UIFont? {
        return self.semibold(withSize: size, italic: false)
    }

    class func semibold(withSize size: CGFloat, italic: Bool) -> UIFont? {
        let attributes: [String] = italic ? [CustomFont.Semibold, CustomFont.Italic] : [CustomFont.Semibold]
        return UIFont(attributes: attributes, size: size)
    }

    // MARK: - .init
    convenience init?(attributes: [String], size: CGFloat) {
        let name = "\(CustomFont.name)-\(attributes.joined(separator: "") )"
        self.init(name: name, size: size)
    }

    // MARK: - HelveticaNeue
    class func helveticaNeueBold(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Bold", size: size)
    }

    // MARK: - Colfax
    class func colfaxRegular(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: "Colfax-Regular", size: size)
    }

    class func colfaxMedium(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: "Colfax-Medium", size: size)
    }

    class func colfaxBold(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: "Colfax-Bold", size: size)
    }

    // MARK: - Brandon Grotesque
    class func brandonGrotesqueBold(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: "BrandonGrotesque-Bold", size: size)
    }

    class func brandonGrotesqueBlack(withSize size: CGFloat) -> UIFont? {
        return UIFont(name: "BrandonGrotesque-Black", size: size)
    }
}
