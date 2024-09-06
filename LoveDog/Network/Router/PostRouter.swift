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
    case fetchUserPost(id: String, param: FetchPostRequest)
    case fetchLikePost(param: FetchPostRequest)
    case uploadPost(param: UploadPostRequest)
    case modifyPost(id: String, param: UploadPostRequest)
    case deletePost(id: String)
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
        case .fetchPostList, .fetchPost, .fetchPostImage, .fetchUserPost, .fetchLikePost:
            return .get
        case .uploadPost, .uploadPostImage, .uploadComments, .like, .follow:
            return .post
        case .deletePost:
            return .delete
        case .modifyPost:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .fetchPostList, .uploadPost:
            return "posts"
        case .fetchPost(let id), .deletePost(let id):
            return "posts/\(id)"
        case .uploadPostImage:
            return "posts/files"
        case .fetchPostImage(let path):
            return path
        case .fetchUserPost(let id, _):
            return "posts/users/\(id)"
        case .fetchLikePost:
            return "posts/likes/me"
        case .uploadComments(let id, _):
            return "posts/\(id)/comments"
        case .like(let id, _):
            return "posts/\(id)/like"
        case .follow(let id):
            return "follow/\(id)"
        case .modifyPost(let id, _):
            return "posts/\(id)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchPostList, .fetchPost, .fetchPostImage, .uploadPost, .deletePost, .fetchUserPost, .fetchLikePost, .uploadComments, .like, .follow, .modifyPost:
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
        case .fetchPostList(let param), .fetchUserPost(_, let param):
            return [
                URLQueryItem(name: "next", value: param.next),
                URLQueryItem(name: "limit", value: param.limit),
                URLQueryItem(name: "product_id", value: param.product_id)
            ]
        case .fetchLikePost(let param):
            return [
                URLQueryItem(name: "next", value: param.next),
                URLQueryItem(name: "limit", value: param.limit)
            ]
        case .fetchPost, .fetchPostImage, .uploadPost, .deletePost, 
                .uploadPostImage, .uploadComments, .like, .follow, .modifyPost:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPostList, .fetchPost, .fetchPostImage, .deletePost, .uploadPostImage, .fetchUserPost, .fetchLikePost, .follow:
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
        case .modifyPost(_, let param):
            let encoder = JSONEncoder()
            return try? encoder.encode(param)
        }
    }
    
}
