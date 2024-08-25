//
//  IntroduceDetailViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class IntroduceDetailViewModel: BaseViewModel {
    
    let fetchAbandonItem: BehaviorRelay<FetchAbandonItem?> = BehaviorRelay(value: nil)
    
    struct Input {
        
    }
    
    struct Output {
        let fetchAbandonItem: Observable<FetchAbandonItem>
    }
    
    func transform(input: Input) -> Output {
        let fetchAbandonItem = fetchAbandonItem.compactMap { $0 }

        return Output(fetchAbandonItem: fetchAbandonItem)
    }
}
