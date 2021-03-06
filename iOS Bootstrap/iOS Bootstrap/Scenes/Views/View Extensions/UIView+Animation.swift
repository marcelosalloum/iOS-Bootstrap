//
//  UIView+Animation.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 15/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import PromiseKit

extension UIView {
    public func animateTouchDown() -> Guarantee<Void> {
        return UIView.animate(.promise, duration: 0.09) {
            self.alpha = 0.89
            self.transform = CGAffineTransform(scaleX: 0.89, y: 0.89)
        }.then { _ -> Guarantee<Bool> in
            UIView.animate(.promise, duration: 0.09) {
                self.alpha = 1
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }.asVoid()
    }

    public func animateColorChange(toColor: UIColor) -> Guarantee<Void> {
        return UIView.animate(.promise, duration: 0.3) {
            self.backgroundColor = toColor
        }.asVoid()
    }
}
