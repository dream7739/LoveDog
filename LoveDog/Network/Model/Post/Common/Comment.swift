//
//  Comment.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import Foundation

struct Comment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    var dateDescription: String {
        let createDate = BaseDateFormatterManager.basicDateFormatter.date(from: createdAt) ?? Date()
        let createDateString = BaseDateFormatterManager.shortDateFormatter.string(from: createDate)
        return createDateString
    }
}
