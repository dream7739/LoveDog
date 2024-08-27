//
//  ProfileResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation

struct ProfileResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let followers: [FollowInfo]
    let following: [FollowInfo]
    let posts: [String]
}

struct FollowInfo: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
