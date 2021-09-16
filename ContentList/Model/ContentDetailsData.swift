//
//  ContentDetailsData.swift
//  ContentList
//
//  Created by Muhammad Riaz on 15/09/2021.
//

import Foundation

struct ContentDetailsData: Decodable {
    
    let item: Item
}

struct Item: Decodable {
    
    var date: String
    var title: String
    var body: String
    var subtitle: String
    var id: Int
}

struct ContentDetailsModel {
    
    var articleTitle: String
    var articleBody: String
    
    init(item: Item) {
        articleTitle = item.title
        articleBody = item.body
    }
}

