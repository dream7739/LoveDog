//
//  APIManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/30/24.
//

import Foundation
import Alamofire
import RxSwift

final class APIManager {
    private init() { }
    static let shared = APIManager()
    
    func callRequest<T: Decodable> (
        request: URLRequest,
        response: T.Type,
        interceptor: RequestInterceptor
    ) -> Single<Result<T, APIError>> {
        let result = Single<Result<T, APIError>>.create { observer in
            AF.request(request, interceptor: interceptor)
                .responseDecodable(of: response.self) { response in
                    let status = response.response?.statusCode ?? 0
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print(error)
                        observer(.success(.failure(APIError(statusCode: status))))
                    }
                }
            return Disposables.create()
        }
        return result
    }
    
    func callRequestEmpty (
        request: URLRequest,
        interceptor: RequestInterceptor
    ) -> Single<Result<Empty, APIError>> {
        let result = Single<Result<Empty, APIError>>.create { observer in
            AF.request(request, interceptor: interceptor)
                .responseDecodable(of: Empty.self, emptyResponseCodes: [200]) { response in
                    let status = response.response?.statusCode ?? 0
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print(error)
                        observer(.success(.failure(APIError(statusCode: status))))
                    }
                }
            return Disposables.create()
        }
        return result
    }
    
    func callRequest<T: Decodable>(
        request: URLRequest,
        response: T.Type
    ) -> Single<Result<T, APIError>> {
        let result = Single<Result<T, APIError>>.create { observer in
            AF.request(request)
                .responseDecodable(of: response.self) { response in
                    let status = response.response?.statusCode ?? 0
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print(error)
                        observer(.success(.failure(APIError(statusCode: status))))
                    }
                }
            return Disposables.create()
        }
        return result
    }
    
    func uploadRequest<T: Decodable>(
        request: URLRequest,
        multipart: MultipartFormData,
        interceptor: RequestInterceptor
    )
    -> Single<T> {
        let result = Single<T>.create { observer in
            AF.upload(multipartFormData: multipart, with: request, interceptor: interceptor)
                .responseDecodable(of: T.self) { response in
                    let status = response.response?.statusCode ?? 0
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure(let error):
                        print(error)
                        observer(.failure(APIError(statusCode: status)))
                    }
                }
            return Disposables.create()
        }
        return result
    }
    
    
    func downloadRequest(
        request: URLRequest,
        interceptor: RequestInterceptor
    )
    -> Single<Result<Data, APIError>> {
        let result = Single<Result<Data, APIError>>.create { observer in
        
            AF.download(request, interceptor: interceptor)
                .responseData { response in
                    let status = response.response?.statusCode ?? 0
                    switch response.result {
                    case .success(let value):
                        let url = request.url!
                        let etag = response.response?.allHeaderFields["Etag"] as? String ?? ""
                        let cachable = Cachable(imageData: value, eTag: etag)
                        ImageCacheManager.shared.cachingImage(url: url, cachable: cachable)
                        ImageCacheManager.shared.cachingDiskImage(url: url, cachable: cachable)
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print(error)
                        observer(.success(.failure(APIError(statusCode: status))))
                    }
                }
            return Disposables.create()
        }
        return result
    }
}
