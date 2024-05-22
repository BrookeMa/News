//
//  LocalArticle.swift
//  News
//
//  Created by Ye Ma on 2024/5/17.
//

import Foundation

public struct LocalArticle: Equatable {
    public let author: String?
    public let title: String
    public let description: String
    public let url: URL
    public let source: String
    public let image: URL?
    public let category: String
    public let language: String
    public let country: String
    public let published: Date
    
    public init(author: String?, title: String, description: String, url: URL, source: String, image: URL?, category: String, language: String, country: String, published: Date) {
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.source = source
        self.image = image
        self.category = category
        self.language = language
        self.country = country
        self.published = published
    }
}
