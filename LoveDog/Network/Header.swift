//
//  Header.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import Foundation

enum HeaderKey: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case sesacKey = "SesacKey"
    case refresh = "Refresh"
}

enum HeaderValue: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}
