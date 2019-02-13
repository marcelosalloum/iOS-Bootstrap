//
//  MyCustomView.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 13/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

@IBDesignable
open class NewsCardView: UIView, NibFileOwnerLoadable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
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
