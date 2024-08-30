//
//  FetchPostResponse.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation

struct FetchPostResponse: Decodable {
    var data: [Post]
    var next_cursor: String //0일경우 추가요청 불가
}
