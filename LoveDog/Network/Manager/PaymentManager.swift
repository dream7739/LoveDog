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
    
    //영수증 검증
    func validationPayment(request: ValidationRequest)
    -> Single<Result<ValidationResponse, APIError>> {
        do {
            let validationRequest = try PaymentRouter.validation(param: request).asURLRequest()
            
            return APIManager.shared.callRequest(
                request: validationRequest,
                response: ValidationResponse.self,
                interceptor: AuthInterceptor.shared
            )
            
        }catch {
            print(#function, "VALIDATION PAYMENT FAILED")
            return Single<Result<ValidationResponse, APIError>>.never()
        }
    }
    
}

