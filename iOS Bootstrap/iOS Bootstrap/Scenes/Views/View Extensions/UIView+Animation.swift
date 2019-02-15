//
//  UIView+Animation.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 15/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

extension UIView {
    public func animateTouchDown(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.9
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { _ in
                completion?()
            })
        })
    }

    public func animateColorChange(toColor: UIColor, _ completion: (() -> Void)? = nil) {
        UIView .animate(withDuration: 0.3, animations: {
            self.backgroundColor = toColor
        }, completion: { _ in

        })
    }
}
