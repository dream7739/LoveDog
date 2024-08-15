//
//  UserManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation
import Alamofire
import RxSwift

//User와 관련된 API 정의
//로그인 / 토큰 갱신
// 1) 액세스 토큰이 만료되었을 때(419) 리프레시 토큰으로 엑세스 토큰 갱신
// 2) 리프레시 토큰이 만료되었을 때(419) 로그인 화면으로 이동하여 로그인 > 리프레시 & 액세스 토큰 재발행
final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    //로그인
    func login(request: LoginRequest) -> Single<Result<LoginResponse, LoginError>> {
        let result = Single<Result<LoginResponse, LoginError>>.create { observer in
            do {
                let loginRequest = try UserRouter.login(param: request).asURLRequest()
                AF.request(loginRequest)
                    .responseDecodable(of: LoginResponse.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(LoginError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "LOGIN REQUEST FAILED")
                observer(.success(.failure(LoginError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    //토큰 갱신
    func refresh() -> Single<Result<AuthResponse, AuthError>> {
        let result = Single<Result<AuthResponse, AuthError>>.create { observer in
            do {
                let refreshRequest = try UserRouter.refresh.asURLRequest()
                AF.request(refreshRequest)
                    .responseDecodable(of: AuthResponse.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(AuthError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "REFRESH REQUEST FAILED")
                observer(.success(.failure(AuthError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    //프로필 조회
    func profile() -> Single<Result<ProfileResponse, NSError>> {
        let result = Single<Result<ProfileResponse, NSError>>.create { observer in
            do {
                let refreshRequest = try UserRouter.profile.asURLRequest()
                AF.request(refreshRequest, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: ProfileResponse.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(NSError(domain: "", code: status))))
                        }
                    }
            }catch {
                print(#function, "PROFILE REQUEST FAILED")
                observer(.success(.failure(NSError(domain: "", code: 0))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
}
