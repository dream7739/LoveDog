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
    let upperCd: Int = 6110000 //시도코드
    let responseType = "json" //응답타입
    var pageNo: Int
    let pageCnt: Int = 20
}
