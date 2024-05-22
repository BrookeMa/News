//
//  ArticleCacheTestHelpers.swift
//  EasyNewsTests
//
//  Created by Ye Ma on 28/01/2023.
//

import Foundation
import News

func uniqueArticle() -> Article {
    return Article(author: "any", title: "any", description: "description \(UUID())", url: anyURL(), source: "any", image: anyURL(), category: "any", language: "any", country: "any", published: Date())
}


func uniqueArticleItem() -> (models: [Article], local: [LocalArticle]) {
    let models = [uniqueArticle(), uniqueArticle()]
    let local = models.map { LocalArticle(author: $0.author,
                                          title: $0.title,
                                          description: $0.description,
                                          url: $0.url,
                                          source: $0.source,
                                          image: $0.url,
                                          category: $0.category,
                                          language: $0.language,
                                          country: $0.country,
                                          published: $0.published)}
    return (models, local)
}

