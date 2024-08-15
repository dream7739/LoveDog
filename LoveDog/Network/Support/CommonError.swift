//
//  CommonError.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation

enum CommonError: Int, Error, LocalizedError {
    case unknownKey   //키값이 없거나 틀릴 경우
    case tooMuchCall  //과호출일 경우
    case invalidURL   //비정상 URL일 경우
    case serverError  //서버 오류
    case unknown      //알 수 없는 오류
    
    init(statusCode: Int) {
        switch statusCode {
        case 420:
            self = .unknownKey
        case 429:
            self = .tooMuchCall
        case 444:
            self = .invalidURL
        case 500:
            self = .serverError
        default:
            self = .unknown
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unknownKey:
            return "인증정보를 확인할 수 없습니다"
        case .tooMuchCall:
            return "과호출이 발생하였습니다"
        case .invalidURL:
            return "잘못된 URL 요청입니다"
        case .serverError:
            return "서버 상의 오류가 발생했습니다"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
}
