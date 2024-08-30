//
//  PaymentRouter.swift
//  LoveDog
//
//  Created by 홍정민 on 8/29/24.
//

import Foundation
import Alamofire

enum PaymentRouter {
    case validation(param: ValidationRequest)
    case paymentList
}

extension PaymentRouter: TargetType {
    
    var baseURL: String {
        return APIURL.sesacBaseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .validation:
            return .post
        case .paymentList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .validation:
            return "payments/validation"
        case .paymentList:
            return "payments/me"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .validation, .paymentList:
            return [
                HeaderKey.contentType.rawValue : HeaderValue.json.rawValue,
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
        case .validation(let param):
            let encoder = JSONEncoder()
            return try? encoder.encode(param)
        default:
            return nil
        }
        
    }
    
}
