//
//  UploadPostImageError.swift
//  LoveDog
//
//  Created by 홍정민 on 8/18/24.
//

import Foundation

enum UploadPostImageError: Error, LocalizedError {
    case badRequest
    case unavailableToken
    case forbidden
    case expiredAccessToken
    case common(_ error: CommonError)
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unavailableToken
        case 403:
            self = .forbidden
        case 419:
            self = .expiredAccessToken
        default:
            self = .common(CommonError.init(statusCode: statusCode))
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다"
        case .unavailableToken:
            return "유효하지 않은 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .expiredAccessToken:
            return "액세스 토큰이 만료되었습니다"
        case .common(let error):
            return error.localizedDescription
        }
    }
}
