//
//  FeedItemsMapperTests.swift
//  NewsTests
//
//  Created by Ye Ma on 2024/5/6.
//

import XCTest
import News

class FeedItemsMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])

        let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            author: "Author 1",
            title: "Title 1",
            description: "Description 1",
            url: URL(string: "http://a-url.com")!,
            source: "Source 1",
            image: URL(string: "http://image-url-1.com")!,
            category: "Category 1",
            language: "Language 1",
            country: "Country 1",
            publishedAt: makeDate("2023-05-06T00:00:00Z")
        )

        let item2 = makeItem(
            author: "Author 2",
            title: "Title 2",
            description: "Description 2",
            url: URL(string: "http://another-url.com")!,
            source: "Source 2",
            image: URL(string: "http://image-url-2.com")!,
            category: "Category 2",
            language: "Language 2",
            country: "Country 2",
            publishedAt: makeDate("2023-05-06T00:00:00Z")
        )

        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
    }

    // MARK: - Helpers

    private func makeItem(author: String, title: String, description: String, url: URL, source: String, image: URL, category: String, language: String, country: String, publishedAt: Date) -> (model: Article, json: [String: Any]) {
        let item = Article(author: author, title: title, description: description, url: url, source: source, image: image, category: category, language: language, country: country, published: publishedAt)
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: publishedAt)
        let json = [
            "author": author,
            "title": title,
            "description": description,
            "url": url.absoluteString,
            "source": source,
            "image": image.absoluteString,
            "category": category,
            "language": language,
            "country": country,
            "published_at": dateString
        ].compactMapValues { $0 }

        return (item, json)
    }
}

