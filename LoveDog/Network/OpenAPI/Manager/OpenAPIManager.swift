//
//  OpenAPIManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import Foundation
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
}
