//
//  NewsProtocols.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 12/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation


protocol ArticleInteractionProtocol: class {
    func userDidSelectArticle(_ selectedArticle: Article)
}
