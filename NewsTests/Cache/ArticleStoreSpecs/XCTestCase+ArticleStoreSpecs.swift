//
//  XCTestCase+ArticleStoreSpecs.swift
//  EasyNewsTests
//
//  Created by Ye Ma on 27/01/2023.
//

import XCTest
import EasyNewsFeature

extension ArticleStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        let articles = uniqueArticleItem().local
        let timestamp = Date()
        
        insert((articles, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedArticle(articles: articles, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNOnEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        let articles = uniqueArticleItem().local
        let timestamp = Date()
        
        insert((articles, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedArticle(articles: articles, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueArticleItem().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueArticleItem().local, Date()), to: sut)
        
        let insertionError = insert((uniqueArticleItem().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueArticleItem().local, Date()), to: sut)
        
        let latestArticle = uniqueArticleItem().local
        let latestTimestamp = Date()
        insert((latestArticle, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedArticle(articles: latestArticle, timestamp: latestTimestamp)), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        let deleteError = deleteCache(from: sut)
        
        XCTAssertNil(deleteError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueArticleItem().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueArticleItem().local, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatSideEffectsRunSerially(on sut: ArticleStore, file: StaticString = #filePath, line: UInt = #line) {
        var completedOpertionsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueArticleItem().local, timestamp: Date()) { _ in
            completedOpertionsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.insert(uniqueArticleItem().local, timestamp: Date()) { _ in
            completedOpertionsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueArticleItem().local, timestamp: Date()) { _ in
            completedOpertionsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOpertionsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order", file: file, line: line)
    }
}

extension ArticleStoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (articles: [LocalArticle], timestamp: Date), to sut: ArticleStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.articles, timestamp: cache.timestamp) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: ArticleStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedArticle { result in
            if case let Result.failure(error) = result { deletionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut: ArticleStore, toRetrieveTwice expectedResult: ArticleStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: ArticleStore, toRetrieve expectedResult: ArticleStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                (.failure, .failure):
                break
                
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(retrieved.articles, expected.articles, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
