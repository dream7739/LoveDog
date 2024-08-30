//
//  PaymentManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/29/24.
//

import Foundation
import Alamofire
import RxSwift

final class PaymentManager {
    
    static let shared = PaymentManager()
    private init() { }
    
    func validationPayment(request: ValidationRequest) -> Single<Result<ValidationResponse, ValidationError>> {
        let result = Single<Result<ValidationResponse, ValidationError>>.create { observer in
            do {
                let validationRequest = try PaymentRouter.validation(param: request).asURLRequest()
                AF.request(validationRequest, interceptor: AuthInterceptor.shared)
                    .responseDecodable(of: ValidationResponse.self) { response in
                        let status = response.response?.statusCode ?? 0
                        print("STATUS CODE ==== \(status)")
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            print(error)
                            observer(.success(.failure(ValidationError.init(statusCode: status))))
                        }
                    }
            }catch {
                print(#function, "VALIDATION PAYMENT FAILED")
                observer(.success(.failure(ValidationError.common(.unknown))))
            }
            
            return Disposables.create()
        }
        
        return result
    }
}
