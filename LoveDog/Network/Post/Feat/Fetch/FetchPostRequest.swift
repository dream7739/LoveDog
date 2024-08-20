//
//  FetchPostRequest.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation

struct FetchPostRequest: Encodable {
    let next: String //페이지네이션에 사용할 커서
    let limit: String = "5" //한 페이지당 개수
    let product_id: String = Constant.ProductId.community
}
