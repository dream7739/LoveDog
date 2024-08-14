//
//  LoginResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import Foundation

struct LoginResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
