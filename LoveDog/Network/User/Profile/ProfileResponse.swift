//
//  ProfileResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation

struct ProfileResponse: Decodable {
    let id: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case nick
    }
}
