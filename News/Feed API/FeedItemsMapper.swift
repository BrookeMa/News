//
//  FeedItemsMapper.swift
//  News
//
//  Created by Ye Ma on 2024/5/6.
//

import Foundation

public final class FeedItemsMapper {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private struct Root: Decodable {
        private let data: [RemoteFeedItem]
        
        private struct RemoteFeedItem: Decodable {
            let author: String?
            let title: String
            let description: String
            let url: URL
            let source: String
            let image: URL?
            let category: String
            let language: String
            let country: String
            let published_at: Date
        }
        
        var articles: [Article] {
            data.map {
                Article(author: $0.author ?? "",
                        title: $0.title,
                        description: $0.description,
                        url: $0.url,
                        source: $0.source,
                        image: $0.image,
                        category: $0.category,
                        language: $0.language,
                        country: $0.country,
                        published: $0.published_at)
            }
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Article] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.articles
    }
}
