//
//  PersonView.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

@IBDesignable
open class DesignableButton: UIButton {

    // MARK: - Custom Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    open override func prepareForInterfaceBuilder() {   // Used for updating the Interface Builder
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    fileprivate func commonInit() {
        self.titleLabel?.font = UIFont.withSize(18)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor.mainColor()

        layer.cornerRadius = 30
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
    }

    // UIView Customizable from Interface Builder
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable open var borderWidth: CGFloat = 3 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable open var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }

    // UIButton Customizable from Interface Builder
    @IBInspectable open var spacingHorizontal: CGFloat = 0 {
        didSet {
            self.imageEdgeInsets = UIEdgeInsets(top: spacingVertical, left: 0, bottom: 0, right: spacingHorizontal)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacingHorizontal, bottom: spacingVertical, right: 0)
        }
    }

    @IBInspectable open var spacingVertical: CGFloat = 0 {
        didSet {
            self.imageEdgeInsets = UIEdgeInsets(top: spacingVertical, left: 0, bottom: 0, right: spacingHorizontal)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacingHorizontal, bottom: spacingVertical, right: 0)
        }
    }

    @IBInspectable open var spacing: CGFloat = 0 {
        didSet {
            let attributes = [NSAttributedString.Key.kern: spacing] as [NSAttributedString.Key: Any]
            self.titleLabel?.attributedText = NSAttributedString(string: (self.titleLabel?.text ?? "")!,
                                                                 attributes: attributes)
        }
    }
}
