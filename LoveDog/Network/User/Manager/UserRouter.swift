//
//  UserRouter.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case login(param: LoginRequest)
    case refresh
    case profile
}

extension UserRouter: TargetType {
    
    var baseURL: String {
        return APIURL.sesacBaseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .refresh:
            return .get
        case .profile:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "users/login"
        case .refresh:
            return "auth/refresh"
        case .profile:
            return "users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login:
            return [
                HeaderKey.contentType.rawValue : HeaderValue.json.rawValue,
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey
            ]
        case .refresh:
            return [
                HeaderKey.authorization.rawValue : UserDefaultsManager.token,
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey,
                HeaderKey.refresh.rawValue: UserDefaultsManager.refresh
            ]
        case .profile:
            return [
                HeaderKey.authorization.rawValue : UserDefaultsManager.token,
                HeaderKey.sesacKey.rawValue : APIKey.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .login(let param):
            let encoder = JSONEncoder()
            return try? encoder.encode(param)
        default:
            return nil
        }
        
    }
    
}
