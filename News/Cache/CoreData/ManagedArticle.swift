//
//  ManagedArticle.swift
//  News
//
//  Created by Ye Ma on 2024/5/17.
//

import CoreData

@objc(ManagedArticle)
class ManagedArticle: NSManagedObject {
    @NSManaged var author: String?
    @NSManaged var title: String
    @NSManaged var desc: String
    @NSManaged var url: URL
    @NSManaged var source: String
    @NSManaged var image: URL?
    @NSManaged var category: String
    @NSManaged var language: String
    @NSManaged var country: String
    @NSManaged var published: Date
    @NSManaged var cache: ManagedCache
}

extension ManagedArticle {
    static func items(from localArticles: [LocalArticle], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localArticles.map { local in
            let managed = ManagedArticle(context: context)
            managed.author = local.author
            managed.title = local.title
            managed.desc = local.description
            managed.url = local.url
            managed.source = local.source
            managed.image = local.image
            managed.category = local.category
            managed.language = local.language
            managed.country = local.country
            managed.published = local.published
            return managed
        })
    }
    
    var local: LocalArticle {
        return LocalArticle(author: author,
                            title: title,
                            description: desc,
                            url: url,
                            source: source,
                            image: image,
                            category: category,
                            language: language,
                            country: country,
                            published: published)
    }
}

