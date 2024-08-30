//
//  PaymentError.swift
//  LoveDog
//
//  Created by 홍정민 on 8/29/24.
//

import Foundation

enum ValidationError: Error, LocalizedError {
    case invalidParameter
    case unavailableToken
    case forbidden
    case alreadyValid
    case notFoundPost
    case expiredAccessToken
    case common(_ error: APIError)
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .invalidParameter
        case 401:
            self = .unavailableToken
        case 403:
            self = .forbidden
        case 409:
            self = .alreadyValid
        case 410:
            self = .notFoundPost
        case 419:
            self = .expiredAccessToken
        default:
            self = .common(APIError.init(statusCode: statusCode))
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidParameter:
            return "잘못된 요청입니다"
        case .unavailableToken:
            return "유효하지 않은 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .alreadyValid:
            return "이미 검증처리 되었습니다"
        case .notFoundPost:
            return "게시글을 찾을 수 없습니다"
        case .expiredAccessToken:
            return "액세스 토큰이 만료되었습니다"
        case .common(let error):
            return error.localizedDescription

        }
    }
}
