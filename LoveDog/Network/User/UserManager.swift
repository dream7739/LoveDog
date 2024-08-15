//
//  UserManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation
import Moya
import RxSwift

final class UserManager {
    
    static let shared = UserManager()
    private let provider = BaseProvider<LoginService>()
    
    private init() { }
    
    func login(request: LoginRequest) -> Single<Result<LoginResponse, NSError>> {
        return provider.callRequest(target: .login(param: request), response: LoginResponse.self)
    }
    
}


enum LoginError: Error, LocalizedError {
    case invalidRequest //필수값이 없는 경우
    case incorrectInfo //계정이 없거나, 비밀번호 불일치
    case common(_ error: CommonError)
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .invalidRequest
        case 401:
            self =  .incorrectInfo
        default:
            self = .common(CommonError.init(statusCode: statusCode))
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "필수값을 채워주세요"
        case .incorrectInfo:
            return "계정을 확인해주세요"
        case .common(let error):
            return error.localizedDescription
        }
    }
}
