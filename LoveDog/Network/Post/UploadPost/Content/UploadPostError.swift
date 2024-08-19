//
//  UploadPostError.swift
//  LoveDog
//
//  Created by 홍정민 on 8/18/24.
//

import Foundation

enum UploadPostError: Error, LocalizedError {
    case unavailableToken
    case forbidden
    case failedUpload
    case expiredRefresh
    case common(_ error: CommonError)
    
    init(statusCode: Int) {
        switch statusCode {
        case 401:
            self = .unavailableToken
        case 403:
            self = .forbidden
        case 410:
            self = .failedUpload
        case 419:
            self = .expiredRefresh
        default:
            self = .common(CommonError.init(statusCode: statusCode))
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unavailableToken:
            return "유효하지 않은 토큰입니다"
        case .forbidden:
            return "접근 권한이 없습니다"
        case .failedUpload:
            return "업로드가 실패하였습니다"
        case .expiredRefresh:
            return "리프레시 토큰이 만료되었습니다"
        case .common(let error):
            return error.localizedDescription
        }
    }
}
