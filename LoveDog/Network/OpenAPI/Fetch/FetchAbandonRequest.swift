//
//  FetchAbandonRequest.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import Foundation

struct FetchAbandonRequest: Encodable {
    let serviceKey: String = APIKey.abondonPublicKey
    let kindCd: Int = 417000 //품종코드
    var upperCd: Int
    let responseType = "json" //응답타입
    var pageNo: Int
    let pageCnt: Int = 20
}
