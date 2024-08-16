//
//  PostManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation
import Alamofire
import RxSwift

final class PostManager {
    
    static let shared = PostManager()
    private init() { }
    
    //게시글 조회
    func fetchPost(request: FetchPostRequest) -> Single<Result<FetchPostResponse, FetchPostError>> {
        let result = Single<Result<FetchPostResponse, FetchPostError>>.create { observer in
            do {
                let fetchPostRequest = try PostRouter.posts(param: request).asURLRequest()
                AF.request(fetchPostRequest, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: FetchPostResponse.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(FetchPostError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "LOGIN REQUEST FAILED")
                observer(.success(.failure(FetchPostError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
 
    
}
