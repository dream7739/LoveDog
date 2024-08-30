//
//  Post.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import Foundation

struct Post: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let price: Int? //가격
    let content: String?
    let content1: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    var likes: [String]
    let likes2: [String] //추후 사용
    let hashTags: [String] //추후 사용
    var comments: [Comment]
    
    var dateDescription: String {
        let date = BaseDateFormatterManager.basicDateFormatter.date(from: createdAt)
        let dateString = BaseDateFormatterManager.longDateFormatter.string(from: date ?? Date())
        let description = "작성일 " + dateString
        return description
    }
}
