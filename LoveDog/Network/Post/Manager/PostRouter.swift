//
//  PostRouter.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case fetchPostList(param: FetchPostRequest)
    case fetchPost(id: String)
    case fetchPostImage(path: String)
    case uploadPost(param: UploadPostRequest)
    case uploadPostImage
    case uploadComments(id: String, param: UploadCommentsRequest)
    case like(id: String, param: Like)
    case follow(id: String)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIURL.sesacBaseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchPostList, .fetchPost, .fetchPostImage:
            return .get
        case .uploadPost, .uploadPostImage, .uploadComments, .like, .follow:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchPostList, .uploadPost:
            return "posts"
        case .fetchPost(let id):
            return "posts/\(id)"
        case .uploadPostImage:
            return "posts/files"
        case .fetchPostImage(let path):
            return path
        case .uploadComments(let id, _):
            return "posts/\(id)/comments"
        case .like(let id, _):
            return "posts/\(id)/like"
        case .follow(let id):
            return "follow/\(id)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchPostList, .fetchPost, .fetchPostImage, .uploadPost, .uploadComments, .like, .follow:
            return [
                HeaderKey.authorization.rawValue: UserDefaultsManager.token,
                HeaderKey.contentType.rawValue : HeaderValue.json.rawValue,
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey
            ]
        case .uploadPostImage:
            return [
                HeaderKey.authorization.rawValue: UserDefaultsManager.token,
                HeaderKey.contentType.rawValue : HeaderValue.multipart.rawValue,
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPostList(let param):
            return [
                URLQueryItem(name: "next", value: param.next),
                URLQueryItem(name: "limit", value: param.limit),
                URLQueryItem(name: "product_id", value: param.product_id)
            ]
        case .fetchPost, .fetchPostImage, .uploadPost, .uploadPostImage, .uploadComments, .like, .follow:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPostList, .fetchPost, .fetchPostImage, .uploadPostImage, .follow:
            return nil
        case .uploadPost(let param):
            let encoder = JSONEncoder()
            return try? encoder.encode(param)
        case .uploadComments(_, let param):
            let encoder = JSONEncoder()
            return try? encoder.encode(param)
        case .like(_, let param):
            let encoder = JSONEncoder()
            return try? encoder.encode(param)
        }
    }
    
}
