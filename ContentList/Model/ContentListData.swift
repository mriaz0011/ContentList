//
//  ContentListData.swift
//  ContentList
//
//  Created by Muhammad Riaz on 15/09/2021.
//

import Foundation

struct ContentListData: Decodable {
    
    let items: [Items]
}

struct Items: Decodable {
    
    let id: Int
    let subtitle: String
    let title: String
    let date: String
}

struct ContentListModel {
    
    var articleId: Int
    var articleTitle: String
    
    init(item: Items) {
        articleId = item.id
        articleTitle = item.title
    }
}
