//
//  StoryViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class StoryViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input { }
    
    struct Output {
        let postList: BehaviorSubject<[Post]>
    }
    
    func transform(input: Input) -> Output {
        let postList: BehaviorSubject<[Post]> = BehaviorSubject(value: [])
        
//        let request = FetchPostRequest(next: "", limit: "5")
//        PostManager.shared.fetchPost(request: request)
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .success(let value):
//                    postList.onNext(value.data)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }.disposed(by: disposeBag)
//        
        
        return Output(postList: postList)
    }
}
