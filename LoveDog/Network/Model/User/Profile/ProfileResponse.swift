//
//  ProfileResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation

struct ProfileResponse: Decodable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    let followers: [FollowInfo]
    var following: [FollowInfo]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case followers
        case following
        case posts
    }
}

struct FollowInfo: Decodable, Hashable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}
