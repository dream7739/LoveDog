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
    
    var abandonRequest = FetchAbandonRequest(upperCd: 6110000, pageNo: 1)
    
    var abandonResponse = FetchAbandonBody(
        items: FetchAbandonItemList(item: []),
        numOfRows: 0,
        pageNo: 0,
        totalCount: 0
    )
    
    struct Input {
        let jsonParse: BehaviorRelay<String>
        let request: BehaviorRelay<FetchAbandonRequest>
        let prefetch: PublishRelay<Void>
    }
    
    struct Output {
        let sidoList: BehaviorRelay<[SidoModel]>
        let abondonList: BehaviorRelay<[FetchAbandonItem]>
        let scrollToTop: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let sidoList = BehaviorRelay<[SidoModel]>(value: [])
        let abondonList = BehaviorRelay<[FetchAbandonItem]>(value: [])
        let scrollToTop = PublishRelay<Void>()
        
        input.request
            .withUnretained(self)
            .distinctUntilChanged { $0.1.upperCd }
            .map {
                self.abandonRequest = $1
                return $1
            }
            .flatMap { request in
                OpenAPIManager.shared.fetchAbondonPublic(request: request)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    guard let body = value.response.body else { return }
                    owner.abandonResponse = body
                    abondonList.accept(body.items.item)
                    
                    if !body.items.item.isEmpty {
                        scrollToTop.accept(())
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.jsonParse
            .flatMap { value in
                JsonManager.configureBundleData(fileName: value, type: [SidoModel].self)
                    .catch { error in
                        print(error.localizedDescription)
                        return Observable.never()
                    }
            }
            .subscribe(with: self) { owner, value in
                sidoList.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.prefetch
            .withUnretained(self)
            .filter { request in
                let count = (self.abandonRequest.pageNo + 1) * (self.abandonRequest.pageCnt)
                return count < self.abandonResponse.totalCount
            }
            .map { _ in
                self.abandonRequest.pageNo += 1
                return self.abandonRequest
            }
            .flatMap { request in
                OpenAPIManager.shared.fetchAbondonPublic(request: request)
            }
            .subscribe { result in
                switch result {
                case .success(let value):
                    guard let body = value.response.body else { return }
                    self.abandonResponse.items.item.append(contentsOf: body.items.item)
                    abondonList.accept(self.abandonResponse.items.item)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            sidoList: sidoList,
            abondonList: abondonList,
            scrollToTop: scrollToTop
        )
    }
}
