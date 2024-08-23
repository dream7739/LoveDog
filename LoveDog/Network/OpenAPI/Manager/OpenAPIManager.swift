//
//  OpenAPIManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit
import Alamofire
import RxSwift

final class OpenAPIManager {
    
    static let shared = OpenAPIManager()
    private init() { }
    
    func fetchAbondonPublic(request: FetchAbandonRequest) -> Single<Result<FetchAbandonResponse, CommonError>> {
        let result = Single<Result<FetchAbandonResponse, CommonError>>.create { observer in
            guard let url = URL(string: APIURL.abondonPublicURL) else {
                observer(.success(.failure(.invalidURL)))
                return Disposables.create()
            }
            
            let parameter: Parameters = [
                "serviceKey": request.serviceKey,
                "upkind": request.kindCd,
                "upr_cd": request.upperCd,
                "_type": request.responseType,
                "pageNo": request.pageNo,
                "numOfRows": request.pageCnt
            ]
            
            AF.request(
                url,
                parameters: parameter,
                encoding: URLEncoding.queryString
            ).responseDecodable(of: FetchAbandonResponse.self) { response in
                let status = response.response?.statusCode ?? 0
                print("STATUS CODE ==== \(status)")
                switch response.result {
                case .success(let value):
                    observer(.success(.success(value)))
                case .failure(let error):
                    print(error)
                    observer(.success(.failure(.unknown)))
                }
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
    func fetchAbondonPublicImage(_ urlString: String) -> Single<Result<UIImage, CommonError>> {
        let result = Single<Result<UIImage, CommonError>>.create { observer in
            
            guard let url = URL(string: urlString) else {
                observer(.success(.failure(.invalidURL)))
                return Disposables.create()
            }
            
            AF.download(url)
                .responseData { response in
                    let status = response.response?.statusCode ?? 0
                    print("STATUS CODE ==== \(status)")
                    switch response.result {
                    case .success(let value):
                        if let image = UIImage(data: value) {
                            ImageCacheManager.shared.cachingImage(url: url, image: image)
                            observer(.success(.success(image)))
                        }else {
                            observer(.failure(CommonError.init(statusCode: status)))
                        }
                    case .failure(let error):
                        print(error)
                        observer(.success(.failure(CommonError.init(statusCode: status))))
                    }
                }
            
            return Disposables.create()
        }
        
        return result
    }
}
