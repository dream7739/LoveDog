//
//  FetchPostResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation

struct FetchPostResponse: Decodable {
    var data: [Post]
    var next_cursor: String //0일경우 추가요청 불가
}

struct Post: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String?
    let content1: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String] //추후 사용
    let hashTags: [String] //추후 사용
    let comments: [Comment]
    
    var dateDescription: String {
        let date = BaseDateFormatter.basicDateFormatter.date(from: createdAt)
        let dateString = BaseDateFormatter.postDateFormatter.string(from: date ?? Date())
        let description = "작성일 " + dateString
        return description
    }
}

struct Creator: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

struct Comment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}
