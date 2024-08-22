//
//  IntroduceViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class IntroduceViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let request: BehaviorRelay<FetchAbandonRequest>
    }
    
    struct Output {
        let abondonList: PublishRelay<[FetchAbandonItem]>
    }
    
    func transform(input: Input) -> Output {
        let abondonList = PublishRelay<[FetchAbandonItem]>()
        
        input.request
            .flatMap { request in
                OpenAPIManager.shared.fetchAbondonPublic(request: request)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    guard let body = value.response.body else { return }
                    abondonList.accept(body.items.item)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
           
        return Output(abondonList: abondonList)
    }
}
