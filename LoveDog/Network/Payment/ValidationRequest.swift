//
//  ValidationRequest.swift
//  LoveDog
//
//  Created by 홍정민 on 8/29/24.
//

import Foundation

struct ValidationRequest: Encodable {
    let impUid: String
    let postId: String
    
    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case postId = "post_id"
    }
}
