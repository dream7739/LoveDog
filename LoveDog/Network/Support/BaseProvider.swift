//
//  BaseProvider.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import Foundation
import Moya
import RxSwift

final class BaseProvider<Provider: TargetType>: MoyaProvider<Provider> {
    
    init() {
        super.init()
    }
    
    func callRequest<T: Decodable>(target: Provider, response: T.Type) -> Single<Result<T, NSError>> {
        let result = Single<Result<T, NSError>>.create { observer in
            self.request(target) { result in
                switch result {
                case .success(let value):
                    do {
                        let json = try JSONDecoder().decode(T.self, from: value.data)
                        observer(.success(.success(json)))
                    }
                    catch {
                        observer(.success(.failure(NSError(domain: "", code: value.statusCode))))
                    }
                    return
                case .failure(let error):
                    observer(.success(.failure(NSError(domain: "", code: 999))))
                }
            }
            
            return Disposables.create()
        }
        
        return result
    }
    
}
