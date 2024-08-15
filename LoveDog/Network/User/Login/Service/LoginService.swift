//
//  LoginService.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import Foundation
import Moya

enum LoginService: TargetType {
    
    case login(param: LoginRequest)
    case refresh
    
    var baseURL: URL {
        let url = URL(string: APIURL.sesacBaseURL)!
        return url
    }
    
    var path: String {
        switch self {
        case .login:
            return "users/login"
        case .refresh:
            return "auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .refresh:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        case .refresh:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return [
                HeaderKey.contentType.rawValue : HeaderValue.json.rawValue,
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey
            ]
        case .refresh:
            return [
                HeaderKey.authorization.rawValue : "토큰토큰",
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey,
                HeaderKey.refresh.rawValue: "리프레시 토큰토큰"
            ]
        }
    }

}
