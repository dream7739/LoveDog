//
//  CommonError.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation

enum APIError: Int, Error, LocalizedError {
    case existImage = 304   //ETAG로 조회한 이미지의 변화가 없을 경우
    case unknownKey = 420   //키값이 없거나 틀릴 경우
    case tooMuchCall = 429 //과호출일 경우
    case invalidURL = 444  //비정상 URL일 경우
    case serverError = 500 //서버 오류
    case unknown      //알 수 없는 오류
    case decoding      //디코딩 에러
    
    init(statusCode: Int) {
        switch statusCode {
        case 304:
            self = .existImage
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
        case .existImage:
            return "이미지의 변경사항이 없습니다"
        case .unknownKey:
            return "인증정보를 확인할 수 없습니다"
        case .tooMuchCall:
            return "과호출이 발생하였습니다"
        case .invalidURL:
            return "잘못된 URL 요청입니다"
        case .serverError:
            return "서버 상의 오류가 발생했습니다"
        case .unknown:
            return "오류가 발생했습니다"
        case .decoding:
            return "디코딩 시 오류가 발생했습니다"
            
        }
    }
}
