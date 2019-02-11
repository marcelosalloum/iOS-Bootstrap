//
//  AppTheme.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 06/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

public enum TextTheme: Int {
    case title = 0
    case titleQuote
    case card
    case cardQuote
    case cardDetail
    case cardFooter
    case questionSubtitle
    case quesionCard

    func font() -> UIFont? {
        switch self {
        case TextTheme.title: return UIFont.withSize(15)
        case TextTheme.titleQuote: return UIFont.withSize(15)
        case TextTheme.card: return UIFont.withSize(15)
        case TextTheme.cardQuote: return UIFont.withSize(15)
        case TextTheme.cardDetail: return UIFont.withSize(15)
        case TextTheme.cardFooter: return UIFont.withSize(15)
        case TextTheme.questionSubtitle: return UIFont.withSize(15)
        case TextTheme.quesionCard: return UIFont.withSize(15)
        }
    }
}

public enum ColorTheme: Int {
    case professional = 0
    case personal
    case romantic
}

public struct LabelSetup {
    var textTheme: TextTheme!
    var colorTheme: ColorTheme!

    init(labelType: TextTheme, appTheme: ColorTheme) {
        self.textTheme = labelType
        self.colorTheme = appTheme
    }

    var font: UIFont? {
        return textTheme.font()
    }

    var color: UIColor {
        switch colorTheme! {
        case ColorTheme.professional:
            switch textTheme! {
            case TextTheme.title: return .white  // professional
            case TextTheme.titleQuote: return .white
            case TextTheme.card: return .white
            case TextTheme.cardQuote: return .white
            case TextTheme.cardDetail: return .white
            case TextTheme.cardFooter: return .white
            case TextTheme.questionSubtitle: return .white
            case TextTheme.quesionCard: return .white
            }
        case ColorTheme.personal:
            switch textTheme! {
            case TextTheme.title: return .white  // personal
            case TextTheme.titleQuote: return .white
            case TextTheme.card: return .white
            case TextTheme.cardQuote: return .white
            case TextTheme.cardDetail: return .white
            case TextTheme.cardFooter: return .white
            case TextTheme.questionSubtitle: return .white
            case TextTheme.quesionCard: return .white
            }
        case ColorTheme.romantic:
            switch textTheme! {
            case TextTheme.title: return .white  // romantic
            case TextTheme.titleQuote: return .white
            case TextTheme.card: return .white
            case TextTheme.cardQuote: return .white
            case TextTheme.cardDetail: return .white
            case TextTheme.cardFooter: return .white
            case TextTheme.questionSubtitle: return .white
            case TextTheme.quesionCard: return .white
            }
        }
    }

}

protocol ColorThemed {
    var colorTheme: ColorTheme { get set }
}
