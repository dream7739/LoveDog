//
//  AuthInterceptor.swift
//  LoveDog
//
//  Created by 홍정민 on 8/15/24.
//

import Foundation
import Alamofire
import RxSwift

final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        //리트라이 후에 새로 갱신된 토큰으로 요청이 수행되도록 함
        print("====ADAPT=====")
        var urlRequest = urlRequest
        urlRequest.headers.add(name: HeaderKey.authorization.rawValue, value: UserDefaultsManager.token)
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        print("=====RETRY=====")
        guard let statusCode = request.response?.statusCode, statusCode == 419 else {
            completion(.doNotRetry)
            return
        }
        
        print("====CURRENT STATUS: \(statusCode)")
        
        //토큰 만료 시 액세스토큰을 갱신하고 재시도 함
        UserManager.shared.refresh()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("=====토큰 갱신 성공 \(value.accessToken)")
                    UserDefaultsManager.token = value.accessToken
                    completion(.retry)
                case .failure(let error):
                    print("=====토큰 갱신 실패===== \(error.localizedDescription)")
                    //리프레시 토큰까지 만료되었을 경우, UserDefaults 값 삭제 후 로그인 화면으로 바꾸어줌
                    UserDefaultsManager.removeTokens()
                    let signInVC = SignInViewController()
                    SceneChanger.transitionScene(signInVC)
                    completion(.doNotRetryWithError(error))
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}
