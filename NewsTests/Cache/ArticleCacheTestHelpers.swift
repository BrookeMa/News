//
//  ArticleCacheTestHelpers.swift
//  EasyNewsTests
//
//  Created by Ye Ma on 28/01/2023.
//

import Foundation
import EasyNewsFeature

func uniqueArticle() -> Article {
    return Article(author: "any", title: "any", description: "description \(UUID())", url: anyURL(), source: "any", image: anyURL(), published: Date())
}

func uniqueArticleItem() -> (models: [Article], local: [LocalArticle]) {
    let models = [uniqueArticle(), uniqueArticle()]
    let local = models.map { LocalArticle(author: $0.author,
                                          title: $0.title,
                                          description: $0.description,
                                          url: $0.url,
                                          source: $0.source,
                                          image: $0.url,
                                          published: $0.published)}
    return (models, local)
}


