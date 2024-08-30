//
//  FollowResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/27/24.
//

import Foundation

struct FollowResponse: Decodable {
    let nick: String
    let opponentNick: String
    let status: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
        case opponentNick = "opponent_nick"
        case status = "following_status"
    }
}
