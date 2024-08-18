//
//  PostRouter.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case fetchPosts(param: FetchPostRequest)
    case fetchPostImage(path: String)
    case uploadPost(param: UploadPostRequest)
    case uploadPostImage
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIURL.sesacBaseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchPosts, .fetchPostImage:
            return .get
        case .uploadPost, .uploadPostImage:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchPosts, .uploadPost:
            return "posts"
        case .uploadPostImage:
            return "posts/files"
        case .fetchPostImage(let path):
            return path
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchPosts, .fetchPostImage, .uploadPost, .uploadPostImage:
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
        case .fetchPosts(let param):
            return [
                URLQueryItem(name: "next", value: param.next),
                URLQueryItem(name: "limit", value: param.limit),
                URLQueryItem(name: "product_id", value: param.product_id)
            ]
        case .fetchPostImage, .uploadPost, .uploadPostImage:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPosts, .fetchPostImage, .uploadPostImage:
            return nil
        case .uploadPost(let param):
            let encoder = JSONEncoder()
            return try? encoder.encode(param)
        }
    }
    
}
