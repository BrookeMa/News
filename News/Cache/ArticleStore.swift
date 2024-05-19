//
//  ArticleStore.swift
//  EasyNews
//
//  Created by Ye Ma on 26/01/2023.
//

import Foundation

public typealias CachedArticle = (articles: [LocalArticle], timestamp: Date)

public protocol ArticleStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedArticle?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    func deleteCachedArticle(completion: @escaping DeletionCompletion)
    func insert(_ articles: [LocalArticle], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
