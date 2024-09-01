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
        let createDate = BaseDateFormatterManager.serverDateFormatter.date(from: createdAt)
        let createDateString = BaseDateFormatterManager.shortDateFormatter.string(from: createDate ?? Date())
        return createDateString
    }
}
