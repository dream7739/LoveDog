//
//  PostRouter.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case posts(param: FetchPostRequest)
    
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIURL.sesacBaseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .posts:
            return .get
            
        }
    }
    
    var path: String {
        switch self {
        case .posts:
            return "posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .posts:
            return [
                HeaderKey.authorization.rawValue: UserDefaultsManager.token,
                HeaderKey.contentType.rawValue : HeaderValue.json.rawValue,
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .posts(let param):
            return [
                URLQueryItem(name: "next", value: param.next),
                URLQueryItem(name: "limit", value: param.limit),
                URLQueryItem(name: "product_id", value: param.product_id)
                ]
        }
    }
    
    var body: Data? {
        return nil
        
    }
    
}
