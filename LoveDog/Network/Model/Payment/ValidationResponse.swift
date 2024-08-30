//
//  ValidatoinResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/29/24.
//

import Foundation

struct ValidationResponse: Decodable {
    let buyerId: String
    let postId: String
    let merchantId: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case buyerId = "buyer_id"
        case postId = "post_id"
        case merchantId = "merchant_uid"
        case productName
        case price
        case paidAt
    }
}
