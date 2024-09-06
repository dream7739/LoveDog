//
//  UserManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation
import Alamofire
import RxSwift

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    //로그인
    func login(request: LoginRequest)
    -> Single<Result<LoginResponse, APIError>> {
        do {
            let loginRequest = try UserRouter.login(param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: loginRequest,
                response: LoginResponse.self
            )
            
        }catch {
            print(#function, "LOGIN REQUEST FAILED")
            return Single<Result<LoginResponse, APIError>>.never()
        }
    }
    
    //토큰 갱신
    func refresh() -> Single<Result<AuthResponse, APIError>> {
        do {
            let refreshRequest = try UserRouter.refresh.asURLRequest()
            
            return APIManager.shared.callRequest(
                request: refreshRequest,
                response: AuthResponse.self
            )
            
        }catch {
            print(#function, "REFRESH REQUEST FAILED")
            return Single<Result<AuthResponse, APIError>>.never()
        }
    }
    
    //프로필 조회
    func profile() -> Single<Result<ProfileResponse, APIError>> {
        do {
            let refreshRequest = try UserRouter.profile.asURLRequest()
            
            return APIManager.shared.callRequest(
                request: refreshRequest,
                response: ProfileResponse.self,
                interceptor: AuthInterceptor.shared
            )
        }catch {
            print(#function, "PROFILE REQUEST FAILED")
            return Single<Result<ProfileResponse, APIError>>.never()
        }
    }
    
}
