//
//  PostManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit
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
                print(#function, "FETCH POST FAILED")
                observer(.success(.failure(FetchPostError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    //게시글 이미지 조회
    func fetchPostImage(path: String) -> Single<Result<UIImage, CommonError>> {
        let result = Single<Result<UIImage, CommonError>>.create { observer in
            do {
                let fetchPostImageResquest = try PostRouter.postImages(path: path).asURLRequest()
                AF.download(fetchPostImageResquest, interceptor: AuthInterceptor.shared)
                    .downloadProgress { progress in
                        print("DOWNLOAD PROGRESS: \(progress.fractionCompleted)")
                    }
                    .responseData { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            if let image = UIImage(data: value) {
                                observer(.success(.success(image)))
                            }else {
                                observer(.failure(CommonError.init(statusCode: status)))
                            }
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(CommonError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "FETCH POST IMAGE REQUEST FAILED")
                observer(.success(.failure(CommonError.unknown)))
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    
    
}
