//
//  UploadPostRequest.swift
//  LoveDog
//
//  Created by 홍정민 on 8/18/24.
//

import Foundation

struct UploadPostRequest: Encodable {
    let title: String
    let content: String
    let content1: String
    let price = 1000
    let product_id = Constant.ProductId.community
    var files: [String]
}
