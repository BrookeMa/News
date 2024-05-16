//
//  FeedLoader.swift
//  News
//
//  Created by Ye Ma on 2024/5/6.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[Article], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
