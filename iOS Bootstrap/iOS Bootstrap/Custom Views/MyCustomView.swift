//
//  MyCustomView.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 13/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

@IBDesignable
open class MyCustomView: UIView, NibFileOwnerLoadable {

    // MARK: - Custom Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        commonInit()
    }

    open override func prepareForInterfaceBuilder() { // Used for updating the Interface Builder
        super.prepareForInterfaceBuilder()
        loadNibContent()
        commonInit()
    }

    fileprivate func commonInit() {
        // Do your view code-customization here
    }
}

//import UIKit
//
//@IBDesignable class MyCustomView: UIView {
//    var contentView: UIView?
//    @IBInspectable var nibName: String?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        xibSetup()
//    }
//
//    func xibSetup() {
//        guard let view = loadViewFromNib() else { return }
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(view)
//        contentView = view
//    }
//
//    func loadViewFromNib() -> UIView? {
//        guard let nibName = nibName else { return nil }
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(
//            withOwner: self,
//            options: nil).first as? UIView
//    }
//
//    override func prepareForInterfaceBuilder() {
//        xibSetup()
//        contentView?.prepareForInterfaceBuilder()
//        self.backgroundColor = UIColor.random()
//        super.prepareForInterfaceBuilder()
//    }
//}
