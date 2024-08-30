//
//  AuthError.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidToken //토큰이 유효하지 않은 경우
    case forbidden //접근권한이 없는 경우
    case expiredRefresh //리프레시 토큰이 만료 된 경우
    case common(_ error: APIError) //그 외
    
    init(statusCode: Int) {
        switch statusCode {
        case 401:
            self = .invalidToken
        case 403:
            self =  .forbidden
        case 418:
            self = .expiredRefresh
        default:
            self = .common(APIError.init(statusCode: statusCode))
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidToken:
            return "유효하지 않은 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .expiredRefresh:
            return "리프레시 토큰이 만료되었습니다"
        case .common(let error):
            return error.localizedDescription
        }
    }
}
